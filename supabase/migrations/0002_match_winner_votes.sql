-- Consensus-based win awarding for Supaspace.
--
-- The match is peer-authoritative, so no single client can be trusted to
-- decide (or self-award) the winner. Instead every client reports who it thinks
-- won, and a point is awarded only once MORE THAN HALF of the reporting players
-- name the same winner. The one-point-per-5-minutes cap from 0001 still applies.
--
-- A match is identified by its shared start timestamp (`startedAt`, epoch ms),
-- which every client in the match agrees on.

create table if not exists public.match_winner_votes (
  match_id          bigint not null,
  voter_id          uuid not null references auth.users (id) on delete cascade,
  winner_id         uuid not null references auth.users (id) on delete cascade,
  winner_name       text not null,
  participant_count integer not null,
  created_at        timestamptz not null default now(),
  primary key (match_id, voter_id)
);

alter table public.match_winner_votes enable row level security;

-- No RLS policies: clients cannot touch this table directly. All access is
-- through report_winner(), which runs as the definer.

-- Parameters are prefixed (p_) so they never collide with the column names
-- below; an unprefixed name in the queries would be ambiguous between the
-- column and the parameter and error at runtime. Replacing requires a drop
-- because the parameter names change.
drop function if exists public.report_winner(bigint, uuid, text, integer);

create function public.report_winner(
  p_match_id bigint,
  p_winner_id uuid,
  p_winner_name text,
  p_participant_count integer
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  voter uuid := auth.uid();
  top_winner_id uuid;
  top_winner_name text;
  top_votes int;
  total_participants int;
begin
  if voter is null then
    raise exception 'not authenticated';
  end if;

  -- Record (or replace) this client's vote for the match.
  insert into public.match_winner_votes (
    match_id, voter_id, winner_id, winner_name, participant_count
  )
  values (
    p_match_id, voter, p_winner_id,
    p_winner_name, greatest(p_participant_count, 1)
  )
  on conflict (match_id, voter_id) do update
    set winner_id         = excluded.winner_id,
        winner_name       = excluded.winner_name,
        participant_count = excluded.participant_count,
        created_at        = now();

  -- The most-voted winner for this match, with the name reported for them.
  select winner_id, max(winner_name), count(*)
    into top_winner_id, top_winner_name, top_votes
  from public.match_winner_votes
  where match_id = p_match_id
  group by winner_id
  order by count(*) desc
  limit 1;

  -- Use the largest reported participant count, so a stray low count can't
  -- lower the bar for a majority.
  select max(participant_count) into total_participants
  from public.match_winner_votes
  where match_id = p_match_id;

  -- Award the winner a point once strictly more than half of the participants
  -- agree. The 5-minute cap (and the fact that votes arrive within seconds)
  -- means the winner is credited at most once per match.
  if top_winner_id is not null and top_votes * 2 > total_participants then
    insert into public.high_scores as existing (
      player_id, player_name, points, last_awarded_at, updated_at
    )
    values (top_winner_id, top_winner_name, 1, now(), now())
    on conflict (player_id) do update
      set points          = existing.points + 1,
          player_name     = excluded.player_name,
          last_awarded_at = now(),
          updated_at      = now()
      where existing.last_awarded_at is null
         or existing.last_awarded_at <= now() - interval '5 minutes';
  end if;
end;
$$;

grant execute on function
  public.report_winner(bigint, uuid, text, integer) to anon, authenticated;

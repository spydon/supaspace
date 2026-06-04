-- Shorten the per-player award cap from 5 to 3 minutes.
--
-- The cap stops a single match from awarding its winner more than once (every
-- client reports, and all those votes land within seconds of each other). It
-- was sized to the match length so a player's legitimate back-to-back wins are
-- never blocked. Matches are now 3 minutes (was 5), so the cap follows: there
-- is always some lobby time before the next match ends, so consecutive wins
-- still count, while a single match still can't award twice.
--
-- Signatures are unchanged, so `create or replace` is enough (no drop). Both
-- the active consensus path (report_winner) and the legacy direct-award
-- function (award_win) are recreated so they stay consistent.

create or replace function public.award_win(player_name text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  current_player uuid := auth.uid();
begin
  if current_player is null then
    raise exception 'not authenticated';
  end if;

  insert into public.high_scores as existing (
    player_id, player_name, points, last_awarded_at, updated_at
  )
  values (current_player, award_win.player_name, 1, now(), now())
  on conflict (player_id) do update
    set points          = existing.points + 1,
        player_name     = excluded.player_name,
        last_awarded_at = now(),
        updated_at      = now()
    -- Only award again once 3 minutes have passed since the last point.
    where existing.last_awarded_at is null
       or existing.last_awarded_at <= now() - interval '3 minutes';
end;
$$;

create or replace function public.report_winner(
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
  -- agree. The 3-minute cap (and the fact that votes arrive within seconds)
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
         or existing.last_awarded_at <= now() - interval '3 minutes';
  end if;
end;
$$;

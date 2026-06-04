-- Persistent high score for Supaspace.
--
-- One row per player account (auth.uid from anonymous sign-in). The winner of
-- a 5-minute match is awarded a single point, but a player can earn at most one
-- point every 5 minutes. That rule is enforced here in the database — not on
-- the (untrusted, peer-authoritative) client — via a SECURITY DEFINER function
-- plus row level security that forbids direct writes.

create table if not exists public.high_scores (
  player_id        uuid primary key references auth.users (id) on delete cascade,
  player_name      text not null,
  points           integer not null default 0,
  last_awarded_at  timestamptz,
  updated_at       timestamptz not null default now()
);

alter table public.high_scores enable row level security;

-- Anyone (including anonymous visitors) may read the leaderboard.
drop policy if exists "high_scores_public_read" on public.high_scores;
create policy "high_scores_public_read"
  on public.high_scores
  for select
  using (true);

-- No INSERT/UPDATE/DELETE policies exist, so clients cannot write directly.
-- All point changes must go through award_win(), which runs as the definer and
-- therefore bypasses RLS while enforcing the 1-point-per-5-minutes rule.

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
    -- Only award again once 5 minutes have passed since the last point.
    where existing.last_awarded_at is null
       or existing.last_awarded_at <= now() - interval '5 minutes';
end;
$$;

grant execute on function public.award_win(text) to anon, authenticated;

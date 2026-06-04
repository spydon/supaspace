# Supaspace

A real-time multiplayer top-down space game built with the [Flame](https://flame-engine.org)
game engine and [Supabase Realtime](https://supabase.com/docs/guides/realtime).
Each match lasts **5 minutes**: fly your ship around, capture as many planets as
you can, and shoot your rivals off theirs. Whoever controls the most planets
when the clock hits zero wins — and earns a point on a persistent high-score
leaderboard.

## Gameplay

- **Call sign.** On first launch you pick a name; it's persisted (along with a
  random ship colour) and reused across sessions. You can change it any time
  from the lobby.
- **Lobby.** A live presence roster shows every connected pilot. You need at
  least **two pilots** to start a match; anyone can press Start. You can also
  flip a Play / Spectate toggle to sit the next match out.
- **Planets.** 10 planets are generated from a shared seed, so every client
  sees the same field. **Capture** one by hovering your ship over it for **5
  seconds**; a progress ring fills as you hold and resets if you leave. Owned
  planets glow in the owner's colour.
- **Contest / takeover.** Captures use **latest-wins** reconciliation, so a
  contested or already-owned planet can be taken over by a more recent capture
  (exact-timestamp ties break on the higher owner id, so all clients converge).
- **Spectating.** Open the game after a match has started and the lobby offers
  **Spectate Live Game** — it reconstructs the running match from a playing
  peer's advertised seed + start time and drops you in as a spectator. A bottom
  bar (`◀ Following … ▶`) cycles the camera through the live ships.
- **Results & leaderboard.** At 0:00 a results screen shows the winner (or a
  tie) and final standings. The sole winner earns **+1** on the persistent
  leaderboard shown in the lobby, **capped at one point per 5 minutes**
  (enforced server-side, see [Architecture](#architecture)).

### Controls

| Input | Action |
|-------|--------|
| Mouse | Aim — the ship turns toward the cursor |
| `W` / `↑` | Thrust |
| `S` / `↓` | Brake |
| Left click (hold) | Shoot — fires continuously while held; a hit knocks the victim back along the shot |
| Hover a planet / powerup for 5s | Capture it |

## Powerups

8 powerups are scattered across the map (deterministically, from the same seed,
avoiding planets and each other). You pick one up the same way you capture a
planet — hover on it for 5 seconds to fill its ring — after which it applies its
effect and animates away on every client. A center-screen toast names what you
grabbed, and a pickup sound plays.

| Powerup | Effect | Toast |
|---------|--------|-------|
| Bullet Speed | Faster bullets (stacks per pickup) | `Bullet Speed +1` |
| Ship Speed | Faster ship — higher top speed and acceleration (stacks) | `Ship Speed +1` |
| Shotgun | Fire a 3-shot forward spread | `Shotgun!` |
| Homing | Your shots gently track nearby ships | `Homing Shots!` |

## Taunts

While you have a ship in play, a row of emoji buttons sits in the bottom-right
of the HUD (😎 🤣 💀 👽 🔥 🖖). Tapping one floats that emoji plus a random
phrase ("Too slow!", "GG EZ", "Yoinked your planet!", …) over your ship and
broadcasts it to every player.

## Audio

- **Background music** loops via [`flutter_soloud`](https://pub.dev/packages/flutter_soloud)
  (`assets/sounds/background.mp3`). Because browsers block autoplay, it starts
  on your first interaction.
- **Sound effects:** a powerup pickup sound, and a random hit sound (one of
  `hit1`–`hit4.mp3`) when your ship is hit.
- A **settings menu** (gear icon, top-right of the lobby) toggles music and
  sound effects independently. Both toggles persist between sessions via
  `shared_preferences`.

## Architecture

- **Flame** drives the world, camera, ships, bullets, planets, powerups, a grid
  backdrop, a minimap, and a fragment-shader starfield (`shaders/starfield.frag`)
  that parallaxes as you fly.
- **Supabase Realtime** handles all multiplayer state on a single **public**
  channel (`supaspace`) — **no per-frame database writes**:
  - **Presence** → the lobby roster, disconnect detection, and advertising an
    in-progress match (seed + start time) so late arrivals can spectate.
  - **Broadcast** → match start, ship state (~20 Hz), shots, captures, powerup
    pickups, and taunts.
  - The channel is public, so the publishable key alone is enough; messages
    from yourself are filtered out, and a channel error/timeout auto-reconnects
    after a short delay.
- **Peer / client-authoritative netcode.** Each client owns its own ship and
  fires its own bullets; remote ships are interpolated from broadcast state.
  The **world is generated deterministically from a shared seed**, so planets,
  powerups and bullet trajectories agree everywhere without syncing positions.
- **Victim-authoritative hits.** Bullets are simulated locally; only the victim
  applies its own knockback (and plays its own hit sound).
- **Persistent high score** is the one piece of durable state. The `high_scores`
  table uses **row level security** (public read; no direct writes) and all
  point changes go through a `SECURITY DEFINER` **`award_win()`** function that
  enforces the **one-point-per-5-minutes** rule in the database — so the
  untrusted client can't farm points. Each browser gets a stable account id via
  anonymous auth.

### Project layout

```
lib/
  main.dart                 Supabase init + anonymous sign-in + settings/sound init
  app.dart                  GameWidget + overlays + pointer/keyboard wiring
  supabase_config.dart      project URL + publishable (anon) key
  game/
    space_game.dart         world, camera, phase machine, capture/powerup/hit logic
    game_phase.dart         GamePhase enum (lobby/playing/spectating/results)
    countdown.dart          shared 5:00 timer
    planet_field.dart       deterministic planet generation
    powerup_field.dart      deterministic powerup placement
    powerup_type.dart       the 4 powerup types + effects/toasts
    taunts.dart             taunt emojis + random phrase pool
    player.dart             per-session identity (name + colour)
    player_store.dart       persists the call sign / identity
    settings_service.dart   music/sfx toggles (shared_preferences)
    sound_service.dart      music + sound effects (flutter_soloud)
    components/             ship, bullet, planet, powerup, grid, minimap,
                            minimap_marker, starfield, taunt_bubble
    net/                    realtime_client, net_events, high_score_service
  ui/                       lobby / hud / name / results / spectate / settings
shaders/starfield.frag      parallax stars + nebula
assets/                     images (bullet + powerups), sounds (music, sfx)
supabase/migrations/        high_scores table, award_win() function, RLS
```

## Setup

1. **Configure Supabase.** The project URL lives in `lib/supabase_config.dart`.
   The **publishable** (anon) key is *not* committed — it's injected at build
   time from the `SUPABASE_ANON_KEY` Dart define (see [Running](#running)). On
   Cloudflare Pages it comes from the `SUPABASE_ANON_KEY` environment
   variable/secret, wired into the build command's `--dart-define`; in CI it
   comes from the `SUPABASE_ANON_KEY` GitHub Actions secret. Use only the
   publishable key (it respects RLS) — never a secret/service key.
2. **Apply the migrations** in `supabase/migrations/` (SQL Editor, Supabase
   CLI, or MCP): `0001_high_scores.sql` creates the leaderboard table and its
   RLS policies, and `0002_match_winner_votes.sql` adds the consensus
   `report_winner()` function (a point is awarded once a majority of players
   report the same winner).
3. **Enable anonymous sign-ins** in the dashboard
   (Authentication → Sign In / Providers). The leaderboard and point awards
   depend on it; the game still runs without it (no points awarded).

## Running

It's a Flutter project, primarily a **web** target (mouse + keyboard). The
`flutter_soloud` web runtime is wired into `web/index.html`. The first build
also runs code generation (freezed / json_serializable).

```bash
flutter pub get
dart run build_runner build
flutter run -d chrome --dart-define=SUPABASE_ANON_KEY=<publishable key>
```

A push to `main` triggers the **Web release build** workflow
(`.github/workflows/web-release.yml`), which produces a wasm-enabled release
build (`flutter build web --release --wasm`).

Open a second browser tab/window at the same URL to get a second pilot, then
start a match. To exercise spectating, start a match in one tab and open
another — it will offer to spectate the live game.

> If `flutter run -d chrome` reports no Chrome device but Chrome is installed,
> point Flutter at it explicitly:
> `export CHROME_EXECUTABLE="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"`

## Development

```bash
flutter analyze        # clean under flame_lint
flutter build web      # also compiles the GLSL shader
```

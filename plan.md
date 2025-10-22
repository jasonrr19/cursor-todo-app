## Cinema List Derby — Implementation Plan (Phased Roadmap)

### Version
- v0.1 aligned with `spec.md` — Friday, October 17, 2025

---

## Phase 1 — Project Setup
- Initialize Rails app (API + server-rendered hybrid), Postgres, Stimulus, SCSS.
- Configure RSpec (or Minitest), RuboCop, simple .env management.
- Basic routes, health check, and home page scaffold with theme toggle (system/light/dark).
- Add base layout with minimalist styling and neon accent tokens.

Deliverables:
- Rails app bootable locally.
- Theming tokens and base SCSS structure.

## Phase 2 — TMDB Integration
- Add TMDB client service with API key config.
- Endpoints for: genres, movie details, credits, search.
- Map TMDB payloads to internal fields (including `decade_bucket`).

Deliverables:
- `TmdbClient` service with typed responses and error handling.
- Integration specs for core calls.

## Phase 3 — Data Model & Migrations
- Implement models and migrations from `spec.md`:
  - Users, UserPreferences, UserPreferredGenres, UserPreferredPeople
  - Movies, Genres, MovieGenres, People, Credits
  - Lists, ListItems, ListShares
  - Reviews, RecommendationEvents, SearchQueries
- Add indexes, uniqueness constraints, and rating/check constraints.

Deliverables:
- All migrations runnable; models with associations and validations.

## Phase 4 — Data Hydration & Seeding
- Seed genres and a small curated set of movies/people via TMDB for demo.
- Background job(s) to hydrate movie details and credits on-demand (when first seen/saved).

Deliverables:
- Seed script and on-demand hydration pipeline.

## Phase 5 — Mock Signup & Onboarding (Preferences)
- Lightweight signup (no auth security) capturing display_name only.
- Preference wizard: genres, main language, country, decade buckets, people (director/crew) search, freeform notes.

Deliverables:
- Wizard flow with persistence to `UserPreferences`, `UserPreferredGenres`, `UserPreferredPeople`.

## Phase 6 — Recommendation Engine (Simple Matching)
- Implement matching service using genres, language, country, decades, and preferred people.
- Sort primarily by match score, then TMDB popularity/vote_count.

Deliverables:
- `RecommendationService` with unit tests; endpoint to fetch recommendations.

## Phase 7 — Serendipity (Opposite-End Suggestions)
- Add two modes: `serendipity_low` (low vote_count) and `serendipity_obscure` (very low popularity & vote_count).
- Inline UX prompt using approved copy and opt-in control.

Deliverables:
- Serendipity suggestions integrated into recommendation endpoint and UI.

## Phase 8 — Lists & Privacy/Sharing
- Create/manage unlimited lists per user but enforce soft cap check at 100 to detect malpractice.
- Add list privacy: private | unlisted | public.
- Basic sharing via `ListShares` (viewer/editor) in a separate tab/flow.

Deliverables:
- List CRUD, add/remove movies, reorder (simple position), privacy controls, sharing UI stub.

## Phase 9 — Reviews
- Member-only reviews: one per (user, movie); rating 1–10; edit/delete allowed.
- Show “Edited” indicator (via `edited_at`/`edit_count`); do not store full revision history.

Deliverables:
- Reviews CRUD with validations; spoiler blur & reveal UX.

## Phase 10 — Search & People/Crew Filters
- Global search page: query + filters (genres, language, country, decades, people).
- Person search (directors/crew) autocomplete backed by TMDB + local cache.

Deliverables:
- Search endpoint and UI with debounced inputs; log `SearchQueries`.

## Phase 11 — UI Components & Pages
- Core pages: Home, Onboarding Wizard, Recommendations, Movie Detail, Lists (index/show), Profile stub.
- Reusable components: MovieCard, PersonPill, GenreTag, RatingBadge, ListPicker, SerendipityPrompt.

Deliverables:
- Navigable app with cohesive minimalist styling and neon accents.

## Phase 12 — Telemetry & Quality
- Log `RecommendationEvents` (strategy, context, accepted) for future tuning.
- Error boundaries and friendly empty/loading states.

Deliverables:
- Basic analytics persisted; improved UX polish.

## Phase 13 — Performance & Indexing Pass
- Verify and add needed DB indexes per `spec.md`.
- N+1 sweeps; cache genre/person lookups; eager loading on detail pages.

Deliverables:
- Profiling notes and applied optimizations.

## Phase 14 — Packaging & Handoff
- README with setup instructions, environment variables, and demo flows.
- Seed data for a compelling demo (e.g., J-horror 2000s).

Deliverables:
- Polished demo-ready repository.

---

### Milestones Summary
- M1: Setup + TMDB client
- M2: Models/Migrations + Seeding
- M3: Onboarding + Recommendations
- M4: Serendipity + Lists
- M5: Reviews + Search
- M6: UI polish + Telemetry + Performance

### Risks & Mitigations
- TMDB rate limits: cache results and hydrate on demand; backoff.
- Data consistency: enforce uniqueness on `tmdb_id`; guard against partial hydration.
- Scope creep: adhere to `spec.md`; non-goals remain out of scope.




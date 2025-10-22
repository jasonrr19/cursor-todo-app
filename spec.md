## Movie Watchlist App — Product & Technical Spec (Source of Truth)

### Version
- v0.1 (Ideation aligned) — Friday, October 17, 2025
 - Site name: Cinema List Derby

### Purpose
- Build a minimalist movie watchlist app that onboards users with simple preference collection, recommends films, and lets users create and manage custom lists. Uses real-world data via TMDB. No production-grade auth/security (demo-only).

## Vision & Principles
- **Minimalist first**: Avoid overwhelming users; progressive disclosure over dense options.
- **Personal yet simple**: Simple preference matching (genres, languages, countries, decades, people) for useful recs fast.
- **Discovery with dignity**: Balance popular picks with serendipitous deep cuts so lesser-known films get a fair shot.
- **Aesthetic**: Dark/light themes with occasional neon accents.

## User Journey
1. Welcome → lightweight signup (no security, demo-only) → preference wizard.
2. Preference wizard collects: genres, main language, country, decade buckets, optional directors/crew, and freeform interests.
3. Landing into recommendations tailored to preferences.
4. Browse cards → add to custom lists (unlimited) → manage lists (privacy levels) → continue discovery.
5. Movie detail pages include member-only reviews (1–10 integer scale, one per user, editable with visible edit state).
6. Alongside popular/highly rated picks, surface a serendipity suggestion (low vote count and optionally very obscure) with opt-in.

## Data Source
- **TMDB** is the authoritative external source for movies, genres, people, and popularity/votes.
- Store `tmdb_id` for movies/people/genres to support hydration and updates.

## Recommendation Strategy (Initial)
- **Primary matching**: Genres, main language, production country, decade buckets, and optional preferred people (directors/crew).
- **Scoring**: Simple rule/weight based. Start with intersect count; break ties with TMDB `popularity`/`vote_count` and recency if needed.
- **Serendipity modes** (user-controllable):
  - Lower vote count: Suggest relevant titles under a low vote_count/popularity percentile.
  - Very obscure: Suggest titles in the lowest decile for both popularity and vote_count, still constrained by the user context (e.g., J-horror 2000s).

## Opposite-End Suggestion UX Copy (draft)
> Also in [facet], here’s a lesser-known film from an under-the-radar director that hasn’t been seen by many users. At Cinema List Derby, we want every film to get a fair shot. Would you like more suggestions like this?

## Domain Model & Relationships

### Relationship Rules (agreed)
- A `movie` belongs to exactly one production country and exactly one main language (we do not track secondary languages or multiple countries for v1).
- One review per user per movie; user can edit or delete their review. Edited reviews should indicate they were edited.
- Users can create unlimited lists; lists have privacy levels; sharing exists but is a separate, unobtrusive feature.
- Preferences use decade buckets (e.g., 1990s, 2000s), not arbitrary year ranges.

### Entity Overview
- Users, UserPreferences, UserPreferredGenres, UserPreferredPeople
- Movies, Genres, MovieGenres
- People (directors/crew), Credits (movie-person with department/job)
- Lists, ListItems, ListShares (optional sharing)
- Reviews (member-only)
- RecommendationEvents, SearchQueries (analytics/telemetry; optional but useful)

### Proposed Schema (Rails-friendly)
```sql
-- USERS
users (
  id                bigint PK,
  email             varchar NULL,            -- mock signup only
  display_name      varchar NOT NULL,
  theme_preference  varchar NOT NULL DEFAULT 'system', -- 'system'|'light'|'dark'
  created_at        timestamptz NOT NULL,
  updated_at        timestamptz NOT NULL
);

user_preferences (
  id                bigint PK,
  user_id           bigint NOT NULL FK -> users(id) UNIQUE,
  preferred_decades jsonb NOT NULL DEFAULT '[]',      -- ["1990s","2000s"]
  preferred_languages jsonb NOT NULL DEFAULT '[]',    -- ISO 639-1 codes
  preferred_countries jsonb NOT NULL DEFAULT '[]',    -- ISO 3166-1 alpha-2
  notes             text NULL,
  created_at        timestamptz NOT NULL,
  updated_at        timestamptz NOT NULL
);

user_preferred_genres (
  id                bigint PK,
  user_id           bigint NOT NULL FK -> users(id),
  genre_id          bigint NOT NULL FK -> genres(id),
  weight            integer NOT NULL DEFAULT 1,
  created_at        timestamptz NOT NULL,
  updated_at        timestamptz NOT NULL,
  UNIQUE(user_id, genre_id)
);

user_preferred_people (
  id                bigint PK,
  user_id           bigint NOT NULL FK -> users(id),
  person_id         bigint NOT NULL FK -> people(id),
  relation          varchar NOT NULL,                 -- 'director','writer','cinematographer', etc.
  weight            integer NOT NULL DEFAULT 1,
  created_at        timestamptz NOT NULL,
  updated_at        timestamptz NOT NULL,
  UNIQUE(user_id, person_id, relation)
);

-- MOVIES & TAXONOMY
movies (
  id                bigint PK,
  tmdb_id           integer NOT NULL UNIQUE,
  title             varchar NOT NULL,
  original_language varchar NOT NULL,                 -- ISO 639-1 main language
  production_country varchar NOT NULL,                -- ISO 3166-1 alpha-2 single country
  release_date      date NULL,
  decade_bucket     varchar NULL,                     -- e.g., '1990s','2000s'
  overview          text NULL,
  runtime_minutes   integer NULL,
  poster_path       varchar NULL,
  backdrop_path     varchar NULL,
  popularity        double precision NULL,
  vote_average      double precision NULL,
  vote_count        integer NULL,
  created_at        timestamptz NOT NULL,
  updated_at        timestamptz NOT NULL
);

genres (
  id                bigint PK,
  tmdb_id           integer NOT NULL UNIQUE,
  name              varchar NOT NULL
);

movie_genres (
  id                bigint PK,
  movie_id          bigint NOT NULL FK -> movies(id),
  genre_id          bigint NOT NULL FK -> genres(id),
  UNIQUE(movie_id, genre_id)
);

people (
  id                bigint PK,
  tmdb_id           integer NOT NULL UNIQUE,
  name              varchar NOT NULL,
  known_for_department varchar NULL,
  profile_path      varchar NULL,
  created_at        timestamptz NOT NULL,
  updated_at        timestamptz NOT NULL
);

credits (
  id                bigint PK,
  movie_id          bigint NOT NULL FK -> movies(id),
  person_id         bigint NOT NULL FK -> people(id),
  department        varchar NOT NULL,                 -- Directing, Writing, etc.
  job               varchar NOT NULL,                 -- Director, Writer, etc.
  order_index       integer NULL,
  created_at        timestamptz NOT NULL,
  updated_at        timestamptz NOT NULL,
  INDEX(movie_id), INDEX(person_id)
);

-- LISTS & SHARING
lists (
  id                bigint PK,
  user_id           bigint NOT NULL FK -> users(id),
  name              varchar NOT NULL,
  description       text NULL,
  privacy           varchar NOT NULL DEFAULT 'private', -- 'private'|'unlisted'|'public'
  created_at        timestamptz NOT NULL,
  updated_at        timestamptz NOT NULL
);

list_items (
  id                bigint PK,
  list_id           bigint NOT NULL FK -> lists(id),
  movie_id          bigint NOT NULL FK -> movies(id),
  note              text NULL,
  position          integer NULL,
  created_at        timestamptz NOT NULL,
  updated_at        timestamptz NOT NULL,
  UNIQUE(list_id, movie_id)
);

list_shares (
  id                bigint PK,
  list_id           bigint NOT NULL FK -> lists(id),
  shared_with_user_id bigint NOT NULL FK -> users(id),
  permission        varchar NOT NULL,                 -- 'viewer'|'editor'
  created_at        timestamptz NOT NULL,
  updated_at        timestamptz NOT NULL,
  UNIQUE(list_id, shared_with_user_id)
);

-- REVIEWS (member-only)
reviews (
  id                bigint PK,
  user_id           bigint NOT NULL FK -> users(id),
  movie_id          bigint NOT NULL FK -> movies(id),
  rating            integer NOT NULL CHECK (rating BETWEEN 1 AND 10),
  title             varchar NULL,
  body              text NOT NULL,
  spoiler           boolean NOT NULL DEFAULT false,
  visibility        varchar NOT NULL DEFAULT 'public', -- 'public'|'followers'|'private'
  edited_at         timestamptz NULL,                 -- indicates visible edit state
  edit_count        integer NOT NULL DEFAULT 0,
  created_at        timestamptz NOT NULL,
  updated_at        timestamptz NOT NULL,
  UNIQUE(user_id, movie_id)
);

-- DISCOVERY & ANALYTICS (optional)
recommendation_events (
  id                bigint PK,
  user_id           bigint NOT NULL FK -> users(id),
  movie_id          bigint NOT NULL FK -> movies(id),
  strategy          varchar NOT NULL,                 -- 'match'|'serendipity_low'|'serendipity_obscure'
  context           jsonb NOT NULL DEFAULT '{}',
  accepted          boolean NULL,
  created_at        timestamptz NOT NULL
);

search_queries (
  id                bigint PK,
  user_id           bigint NOT NULL FK -> users(id),
  query             varchar NOT NULL,
  filters           jsonb NOT NULL DEFAULT '{}',
  created_at        timestamptz NOT NULL
);
```

### Rails Model Relationships (summary)
- `User` has one `UserPreference`; has many `UserPreferredGenres`, `UserPreferredPeople`, `Lists`, `Reviews`, `RecommendationEvents`, `SearchQueries`.
- `Movie` has many `MovieGenres` → many `Genres`; has many `Credits` → many `People`; has many `ListItems`, `Reviews`, `RecommendationEvents`.
- `Person` has many `Credits` → many `Movies`.
- `List` belongs to `User`; has many `ListItems` → many `Movies`; has many `ListShares`.
- `Review` belongs to `User` and `Movie`; one per (user, movie), editable (show edited state).

## Reviews
- **Scale**: 1–10 integers, no half-stars.
- **Uniqueness**: One review per user per movie (enforced). Users may edit or delete their review.
- **Edited indicator**: Show if edited; store `edited_at` and `edit_count`.
 - **History**: Do not store full revision history beyond the edited markers.

## Lists
- **Unlimited** per user but will stop at 100 to check for any malpractice occuring.
- **Privacy**: `private` | `unlisted` | `public`.
- **Sharing**: Optional, separate tab/flow; does not clutter core watchlist flow. Permissions: `viewer` or `editor`.

## Preference Collection (Onboarding)
- Genres (multi-select)
- Main language (single; ISO 639-1)
- Country (single; ISO 3166-1 alpha-2)
- Decade buckets (multi-select)
- People (directors/crew) search and select
- Freeform interests (text)

## UI/UX
- **Theme**: System default with toggle for light/dark; neon accents for CTAs/focus.
- **Layout**: Clean card grid for movies; single-column on mobile; clear Save-to-List action.
- **Serendipity control**: Inline prompt to opt into low-vote or very obscure suggestions.
- **Spoiler handling**: Blur spoilers in review bodies with reveal on click.

## Non-Goals (explicitly out of scope for now)
- Anything earlier categorized as “Later”: follows/graph features, advanced algorithmic blending beyond simple matching, email digests, import/export, etc.
- Production-grade authentication and security.

## Technical Stack
- **Backend**: Ruby on Rails (API + server-rendered views or hybrid), PostgreSQL.
- **Frontend**: JavaScript (vanilla/Stimulus) + SCSS.
- **External**: TMDB API for data.

## Integration Notes (TMDB)
- Store and index `tmdb_id` for `movies`, `people`, `genres`.
- Hydrate movie: details, primary language, primary country, release date → derive `decade_bucket`.
- Credits endpoint to populate `people` and `credits` (departments/jobs).
- Use `popularity` and `vote_count` for sorting and serendipity thresholds.

## Indexing & Performance (initial)
- `movies(tmdb_id)` unique; indexes on `(decade_bucket)`, `(original_language)`, `(production_country)`, `(popularity DESC)`, `(vote_count DESC)`.
- `movie_genres(movie_id, genre_id)` unique; indexes on `movie_id`, `genre_id`.
- `credits(movie_id)`, `credits(person_id)` indexes.
- `reviews(user_id, movie_id)` unique with supporting indexes on `movie_id`.
- `lists(user_id)`; `list_items(list_id, movie_id)` unique with indexes.

## Recommendation Controls (config)
- `SERENDIPITY_LOW_VOTE_MAX_PERCENTILE` (e.g., 30%)
- `SERENDIPITY_OBSCURE_MAX_PERCENTILE` (e.g., 10%)
- Per-genre/decade minimum quality gates (e.g., exclude vote_count < N if no match context).

## Success Criteria (MVP)
- Users can complete onboarding with preferences including people and decades.
- Recommendations show relevant matches plus an opposite-end suggestion with user opt-in modes.
- Users can create unlimited lists, set privacy, and add movies quickly.
- Movies support member-only reviews with edit indicator and 1–10 ratings.
- Minimalist UI with theme toggle and tasteful neon accents.

## Open Items (to confirm later)
- Exact serendipity thresholds and UI placement for the prompt.

---
This document is the source of truth for scope and decisions for the MVP. Any changes should be reflected here before implementation.



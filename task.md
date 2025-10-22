## Cinema List Derby — Task Breakdown (Per Phase Checklists)

Track granular, actionable tasks derived from `plan.md`. Each task is sized for a single focused session.

---

### Phase 1 — Project Setup
- [x] Initialize Rails app with Postgres and minimal views
- [x] Add Stimulus and set up JS bundling
- [x] Add SCSS pipeline and base variables (neon accents)
- [x] Configure .env and TMDB API key placeholders
- [x] Add RuboCop config and run initial lint
- [x] Choose test framework and bootstrap (RSpec or Minitest)
- [x] Create health check route/controller
- [x] Add base layout with theme toggle (system/light/dark)
- [x] Document setup steps in README

### Phase 2 — TMDB Integration
- [x] Add `TmdbClient` service for GET with API key auth
- [x] Implement method: fetch genres
- [x] Implement method: fetch movie details by tmdb_id
- [x] Implement method: fetch credits by tmdb_id
- [x] Implement method: search movies by query
- [x] Implement method: search people (directors/crew)
- [x] Add simple error handling and rate limit backoff
- [x] Write specs for client methods

### Phase 3 — Data Model & Migrations
- [x] Create models/migrations: Users, UserPreferences
- [x] Create models/migrations: UserPreferredGenres, UserPreferredPeople
- [x] Create models/migrations: Movies, Genres, MovieGenres
- [x] Create models/migrations: People, Credits
- [x] Create models/migrations: Lists, ListItems, ListShares
- [x] Create models/migrations: Reviews, RecommendationEvents, SearchQueries
- [x] Add indexes and uniqueness constraints per spec
- [x] Add validations and associations in models

### Phase 4 — Data Hydration & Seeding
- [x] Seed genres from TMDB
- [x] Seed a curated demo set (e.g., J-horror 2000s)
- [x] Build on-demand hydration for movies not in DB
- [x] Background job to fetch and persist credits
- [x] Add rake tasks for hydration/seed flows

### Phase 5 — Mock Signup & Onboarding (Preferences)
- [x] Create mock signup form (display_name only)
- [x] Build preference wizard shell (multi-step)
- [x] Step: select genres (multi)
- [x] Step: select main language (single)
- [x] Step: select country (single)
- [x] Step: select decade buckets (multi)
- [x] Step: search/select people (directors/crew)
- [x] Step: freeform interests
- [x] Persist to UserPreferences and related joins
- [x] Add simple welcome/finish screen

### Phase 6 — Recommendation Engine (Simple Matching)
- [x] Implement `RecommendationService` matcher
- [x] Define scoring and tie-break rules
- [x] Add endpoint to fetch recommendations for current user
- [x] Unit tests for core matching logic

### Phase 7 — Serendipity (Opposite-End Suggestions)
- [x] Implement `serendipity_low` mode (low vote_count)
- [x] Implement `serendipity_obscure` mode (lowest decile popularity & vote_count)
- [x] Add config for percentiles
- [x] Add inline UX prompt with approved copy
- [x] Track `RecommendationEvents` for serendipity

### Phase 8 — Lists & Privacy/Sharing
- [x] List CRUD (create, rename, delete)
- [x] Add movie to list (from cards and detail)
- [x] Remove movie from list
- [x] Reorder list items (position field)
- [x] Enforce soft cap check at 100 lists/user
- [x] Privacy control per list (private/unlisted/public)
- [x] Sharing tab with `viewer`/`editor` roles (basic UI)

### Phase 9 — Reviews
- [x] Review create (rating 1–10, body, optional title)
- [x] Review edit with "Edited" indicator
- [x] Review delete
- [x] Spoiler blur and reveal
- [x] Validate one review per user per movie

### Phase 10 — Search & People/Crew Filters
- [x] Build search endpoint with filters (genres, language, country, decades, people)
- [x] Debounced search UI with suggestion results
- [x] Person autocomplete backed by TMDB + local cache
- [x] Log `SearchQueries` for submissions

### Phase 11 — UI Components & Pages
- [x] MovieCard component (save button, rating badge)
- [x] PersonPill and GenreTag components
- [x] ListPicker modal/sheet
- [x] SerendipityPrompt component
- [x] Pages: Home, Onboarding, Recommendations, Movie Detail, Lists index/show, Profile stub
- [x] Light/dark themes with neon accents

### Phase 12 — Telemetry & Quality
- [x] Record `RecommendationEvents` on impressions and accepts
- [x] Friendly empty states and loading skeletons
- [x] Error pages and boundary handling

### Phase 13 — Performance & Indexing Pass
- [x] Add missing indexes per real usage
- [x] Cache genre/person lookups
- [x] Eager-load associations for detail/recs

### Phase 14 — Packaging & Handoff
- [x] README: setup, env vars, workflows
- [x] Demo seed storyline (e.g., J-horror 2000s lists)
- [x] Final polish QA pass

### Phase 15 — General Fixes & Enhancements

#### Search & Results
- [x] Fix search persistence - Allow multiple consecutive searches without page refresh
- [x] Improve search relevance - Prioritize exact title matches and official franchise films
- [x] Increase search results - Show more results per search (currently 19-20)
- [x] Add pagination - Implement "Load More" or page navigation for search results
- [x] Filter out 0.0 vote movies - Exclude movies with 0 votes from search results

#### Movie Interaction & Tracking
- [x] Add "Mark as Watched" functionality - Allow users to mark any movie as watched from anywhere
- [x] Implement watched status impact - Update recommendation engine to factor in watched movies
- [x] Movie detail page - Create dedicated movie detail view with full information
- [x] Fix watched button persistence - Keep watched state without page refresh, show review button immediately
- [x] Dynamic review button - Show "Write Review" button when movie is marked as watched without refresh

#### List Management
- [x] Enhanced "Add to List" - Prompt user to choose existing list or create new one when adding movie
- [x] Create list from home - Add "Create New List" button on home screen
- [x] Remove test buttons - Clean up "Test Search" and "Test Auto-Pop" development buttons

#### Reviews System
- [x] Fix review routing errors - Resolve "movie not found" errors when creating/canceling reviews
- [x] Allow reviews from anywhere - Enable review creation from any page (not just recommendations)
- [x] Restrict reviews to watched movies - Only allow reviews for movies marked as watched
- [x] Fix review submission - Ensure review form successfully saves and redirects
- [x] Fix review cancel button - Ensure cancel properly returns to previous page
- [x] Highlight selected rating - Visual feedback on rating selection in review form
- [x] Add navigation to My Reviews - Add buttons for homepage and movie details

#### Site-Wide Navigation
- [x] Create persistent navbar - Add sticky navigation bar to all pages
- [x] Include all major sections - Home, Recommendations, Lists, Reviews, Watched
- [x] Integrate theme toggle - Move theme toggle into navbar
- [x] Mobile responsive design - Navbar adapts to smaller screens
- [x] Remove redundant home button - Logo serves as home link
- [x] Fix watched movies page - Correct instance variable bug

#### UI Polish
- [x] Prevent text selection on hero - Disable text highlighting/selection on home page hero text


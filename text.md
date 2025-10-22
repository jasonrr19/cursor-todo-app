Cinema List Derby — Session Transcript & Project State Snapshot

Date: Friday, October 17, 2025

Summary of Conversation & Decisions
1) Concept
- Build a minimalist movie watchlist app with onboarding preferences and recommendations; users create named lists and add movies. Avoid overwhelming UI, dark/light theme with neon accents.

2) Data Source
- Use TMDB as the reliable external API. Persist tmdb_id for movies/people/genres.

3) Recommendations
- Simple matching on genres, main language, single production country, decade buckets, and preferred people (directors/crew).
- Serendipity: two modes — low vote count and very obscure. Inline prompt asks if user wants such suggestions.

4) Reviews
- Member-only reviews; rating 1–10 integers (no halves). One review per user per movie. Editable/deletable with visible edited indicator; do not keep full revision history.

5) Lists
- Unlimited in spirit, but soft check at 100 per user to detect malpractice. Privacy: private | unlisted | public. Sharing via separate tab (viewer/editor), unobtrusive to core flow.

6) Movie Relationships
- Each movie has exactly one main language and one production country (no secondary tracking for v1).

7) Branding
- Site name: Cinema List Derby.

Files Created/Updated This Session
- spec.md: Source of truth for product scope, data model, relationships, UX, indexing, and success criteria.
- plan.md: Phased roadmap from setup → TMDB → models → onboarding → recs → serendipity → lists → reviews → search → UI → telemetry → performance → packaging.
- task.md: Granular, per-phase checklists sized for single sessions.

Current Codebase State
- Rails app initialized in repo (PostgreSQL, esbuild, Sass) [tests skipped for RSpec setup].
- Stimulus installation pending due to environment hiccup; bin line-endings fix and bundler install were planned next.

Outstanding Tasks (from task.md, Phase 1)
- Add Stimulus and set up JS bundling
- Add SCSS pipeline variables (neon)
- Configure .env and TMDB key placeholder
- Add RuboCop + initial lint
- Add/choose test framework (RSpec)
- Create health check route/controller
- Add base layout with theme toggle (system/light/dark)
- Document setup steps in README

How We Paused
- User requested to stop; we paused before installing bundler/Stimulus. Next resume step: fix bin line endings, install bundler, bundle install, then run `bin/rails stimulus:install`.

Key Specs Snapshot (from spec.md)
- One review per user/movie, 1–10 integer rating, edited indicator only (no history)
- Movie belongs to one country, one main language
- Decade buckets for time preferences
- Serendipity modes: low vote and very obscure
- Lists: soft check at 100 per user, privacy/share options

Next Recommended Step on Resume
1. Normalize bin line endings and install bundler/gems.
2. Run Stimulus installer and commit changes.
3. Proceed through Phase 1 checklist, then Phase 2 (TMDB client).

End of snapshot.



#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

# Reset and seed database for fresh deployment
echo "🎬 Resetting and seeding database..."
bundle exec rails db:seed:replant DISABLE_DATABASE_ENVIRONMENT_CHECK=1

# Fetch missing poster paths from TMDB
echo "🖼️  Fetching missing poster paths from TMDB..."
bundle exec rails db:movies:fetch_missing_posters

# Remove any inappropriate films that may have been added
echo "🧹 Cleaning up inappropriate content..."
bundle exec rails db:movies:remove_inappropriate


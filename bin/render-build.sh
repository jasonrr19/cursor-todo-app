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


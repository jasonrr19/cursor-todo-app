# Cinema List Derby 🎬

A Ruby on Rails application for discovering, organizing, and getting personalized movie recommendations. Built with TMDB API integration, featuring serendipity discovery of hidden gems, custom lists, and comprehensive movie reviews.

## Features

### Core Functionality
- 🎥 **Movie Search** - Search TMDB's extensive database with advanced filters
- 🎯 **Personalized Recommendations** - Get movie suggestions based on your preferences
- ✨ **Serendipity Discovery** - Find hidden gems and obscure films you'd never discover otherwise
- 📝 **Movie Reviews** - Write and share reviews with spoiler protection
- 📋 **Custom Lists** - Organize movies into unlimited lists with privacy controls
- 🎨 **Dark/Light Themes** - Beautiful UI with neon accents in both light and dark modes

### Advanced Features
- **Smart Filtering** - Search by genres, languages, countries, decades, and people
- **People Search** - Find movies by directors, actors, and other crew members
- **Telemetry** - Track recommendation impressions and user interactions
- **Performance** - Optimized with caching and database indexes
- **Empty States** - Friendly UI for empty data states
- **Error Pages** - Cinema-themed custom error pages

## Tech Stack

- **Backend**: Ruby on Rails 7.1
- **Database**: SQLite (development), PostgreSQL (production-ready)
- **Frontend**: HTML5, Vanilla JavaScript, Stimulus
- **Styling**: SCSS with CSS variables for theming
- **API**: TMDB (The Movie Database) API
- **HTTP**: HTTParty for API requests
- **Testing**: RSpec, FactoryBot, WebMock

## Prerequisites

- Ruby 3.2.0 or higher
- Rails 7.1.5 or higher
- SQLite3 (for development)
- TMDB API Key ([Get one here](https://www.themoviedb.org/settings/api))

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd Cursor-AI-todo-app
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Configure Environment Variables

Create a `.env` file in the root directory:

```bash
# .env
TMDB_API_KEY=your_api_key_here
TMDB_API_READ_ACCESS_TOKEN=your_read_access_token_here
```

Or set them directly in `config/initializers/tmdb.rb` (not recommended for production):

```ruby
Rails.application.config.tmdb = {
  api_key: 'your_api_key_here',
  api_read_access_token: 'your_read_access_token_here',
  base_url: 'https://api.themoviedb.org/3',
  image_base_url: 'https://image.tmdb.org/t/p'
}
```

### 4. Database Setup

```bash
# Create database
rails db:create

# Run migrations
rails db:migrate

# (Optional) Load demo seed data
rails db:seed
```

### 5. Start the Server

```bash
rails server
```

Visit `http://localhost:3000` to see the application!

## Project Structure

```
app/
├── controllers/       # Request handlers
│   ├── movies_controller.rb
│   ├── recommendations_controller.rb
│   ├── lists_controller.rb
│   ├── reviews_controller.rb
│   └── ...
├── models/            # Data models
│   ├── movie.rb
│   ├── user.rb
│   ├── list.rb
│   ├── review.rb
│   └── ...
├── services/          # Business logic
│   ├── movie_search_service.rb
│   ├── recommendation_service.rb
│   └── tmdb_client.rb
├── views/             # HTML templates
│   ├── pages/
│   ├── recommendations/
│   ├── lists/
│   └── shared/        # Reusable components
└── assets/
    ├── stylesheets/
    └── javascript/

config/
├── routes.rb          # URL routing
├── database.yml       # Database configuration
└── initializers/
    └── tmdb.rb        # TMDB API configuration

db/
├── migrate/           # Database migrations
├── schema.rb          # Database schema
└── seeds.rb           # Demo seed data
```

## Key Workflows

### User Onboarding

1. **Sign Up** - Create account with display name (no passwords in demo)
2. **Set Preferences** - Select favorite genres, countries, languages, decades
3. **Choose People** - Search for favorite directors and actors
4. **Get Recommendations** - Personalized movie suggestions based on preferences

### Movie Discovery

1. **Search** - Use the search bar with optional filters:
   - Genre (Action, Drama, Horror, etc.)
   - Decade (1950s-2020s)
   - Language (English, Japanese, French, etc.)
   - Country (USA, Japan, France, etc.)
   - People (Directors, Actors)

2. **Serendipity** - Discover hidden gems:
   - **Low Vote Count** - Films with fewer than average votes
   - **Very Obscure** - Ultra-rare films you've never heard of

3. **Browse Recommendations** - Get personalized suggestions on the home page

### List Management

1. **Create Lists** - Organize movies into custom collections
2. **Privacy Levels**:
   - 🔒 **Private** - Only you can see
   - 🔗 **Unlisted** - Anyone with link can see
   - 🌐 **Public** - Visible to all users
3. **Add Movies** - Click "Add to List" on any movie card
4. **Reorder** - Drag and drop to reorder movies (if implemented)

### Writing Reviews

1. Navigate to a movie
2. Click "Write Review"
3. Add:
   - **Rating** (1-10 scale)
   - **Title** (optional)
   - **Review Text**
   - **Spoiler Warning** (checkbox)
4. Submit - Reviews can be edited later

## API Endpoints

### Movies
- `GET /movies/search?q=query` - Search movies
- `GET /movies/search_people?q=query` - Search people
- `GET /movies/genres` - Get all genres
- `GET /movies/countries` - Get all countries
- `GET /movies/languages` - Get all languages
- `GET /movies/:id` - Get movie details

### Recommendations
- `GET /recommendations` - Get personalized recommendations
- `GET /recommendations/serendipity?mode=low|obscure` - Serendipity suggestions
- `POST /recommendations/track_event` - Track recommendation events

### Lists
- `GET /lists` - User's lists
- `POST /lists` - Create new list
- `GET /lists/:id` - View list details
- `PATCH /lists/:id` - Update list
- `DELETE /lists/:id` - Delete list

### Reviews
- `GET /my-reviews` - User's reviews
- `GET /reviews/:id` - View review
- `POST /movies/:movie_id/reviews` - Create review
- `PATCH /reviews/:id` - Update review
- `DELETE /reviews/:id` - Delete review

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `TMDB_API_KEY` | Your TMDB API key | Yes |
| `TMDB_API_READ_ACCESS_TOKEN` | Your TMDB read access token | Yes |
| `RAILS_ENV` | Environment (development/test/production) | No |
| `DATABASE_URL` | PostgreSQL connection string (production) | Production only |

## Caching

The application uses Rails.cache for performance:

- **Genres**: 24 hours (rarely change)
- **People**: 24 hours for TMDB ID lookups, 1 hour for searches
- **Countries/Languages**: 24 hours

Clear cache if needed:
```ruby
rails runner "Genre.clear_cache; Person.clear_cache; Rails.cache.clear"
```

## Database Indexes

Optimized indexes for common queries:
- Movie searches (title, TMDB ID, release date, vote metrics)
- Genre/People lookups (TMDB IDs, names)
- List associations (user_id, movie_id)
- Review lookups (user_id, movie_id, rating)
- Recommendation events (user_id, event_type, created_at)

## Testing

```bash
# Run all tests
rspec

# Run specific test file
rspec spec/models/movie_spec.rb

# Run with coverage
COVERAGE=true rspec
```

## Deployment

### Heroku Deployment

1. Create Heroku app:
```bash
heroku create your-app-name
```

2. Add PostgreSQL:
```bash
heroku addons:create heroku-postgresql:mini
```

3. Set environment variables:
```bash
heroku config:set TMDB_API_KEY=your_api_key
heroku config:set TMDB_API_READ_ACCESS_TOKEN=your_token
```

4. Deploy:
```bash
git push heroku main
heroku run rails db:migrate
heroku run rails db:seed
```

## Troubleshooting

### TMDB API Issues
- **401 Unauthorized**: Check your API key is correct
- **429 Too Many Requests**: TMDB rate limit reached, wait a moment
- **404 Not Found**: Movie/person doesn't exist in TMDB

### Database Issues
- **Pending migrations**: Run `rails db:migrate`
- **Locked database**: Stop all Rails processes, delete `tmp/pids/server.pid`
- **Missing tables**: Run `rails db:schema:load`

### Performance Issues
- **Slow queries**: Check database indexes with `rails db:migrate:status`
- **Cache issues**: Clear cache with `rails runner "Rails.cache.clear"`

## Contributing

This is a demo application showcasing Rails best practices:
- RESTful API design
- Service objects for business logic
- Comprehensive database indexing
- Caching strategies
- Eager loading to prevent N+1 queries
- Telemetry and analytics
- Responsive UI with dark/light themes

## License

This project is provided as-is for educational and demonstration purposes.

## Acknowledgments

- Movie data provided by [The Movie Database (TMDB)](https://www.themoviedb.org/)
- Built with Ruby on Rails
- Inspired by the need for better serendipity in movie discovery

---

**Made with ❤️ for movie lovers who want to discover hidden gems**

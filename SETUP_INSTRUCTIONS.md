# Ruby on Rails Setup Instructions

## Prerequisites Installation

### 1. Install Ruby on Windows
1. Go to https://rubyinstaller.org/
2. Download the latest **Ruby+Devkit** version (Ruby 3.3.x recommended)
3. Run the installer and follow these steps:
   - Check "Add Ruby executables to your PATH"
   - Check "Associate .rb and .rbw files with this Ruby installation"
   - When prompted about MSYS2, choose option 3 to install the full development toolkit
4. Restart your terminal/PowerShell

### 2. Verify Installation
Open a new terminal and run:
```bash
ruby --version
gem --version
```

### 3. Install Rails
```bash
gem install rails
```

## Quick Setup
Once Ruby and Rails are installed, you can run the provided `setup_rails_app.bat` file, or follow the manual steps below.

## Manual Setup Steps

1. **Create Rails Application**:
   ```bash
   rails new todo_app --database=sqlite3 --skip-test --skip-system-test
   cd todo_app
   ```

2. **Add SCSS and JavaScript Support**:
   ```bash
   bundle add sass-rails
   bundle add webpacker
   rails webpacker:install
   rails stimulus:install
   ```

3. **Install Bootstrap**:
   ```bash
   yarn add bootstrap @popperjs/core
   ```

4. **Start the Server**:
   ```bash
   rails server
   ```

Visit http://localhost:3000 to see your application running!

## Project Structure
- `app/controllers/` - Rails controllers
- `app/models/` - Rails models
- `app/views/` - HTML templates (ERB)
- `app/assets/stylesheets/` - SCSS files
- `app/javascript/` - JavaScript files
- `config/routes.rb` - URL routing




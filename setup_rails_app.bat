@echo off
echo Setting up Ruby on Rails application...

REM Check if Ruby is installed
ruby --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Ruby is not installed. Please install Ruby from https://rubyinstaller.org/
    echo Download the Ruby+Devkit version and run the installer.
    pause
    exit /b 1
)

echo Ruby is installed. Checking Rails...
rails --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Rails...
    gem install rails
)

echo Creating new Rails application...
rails new todo_app --database=sqlite3 --skip-test --skip-system-test

echo Changing to application directory...
cd todo_app

echo Installing additional gems for SCSS and JavaScript...
bundle add sass-rails
bundle add webpacker

echo Setting up Webpacker for JavaScript...
rails webpacker:install

echo Setting up Stimulus for JavaScript functionality...
rails stimulus:install

echo Installing Bootstrap for styling...
yarn add bootstrap @popperjs/core

echo Application setup complete!
echo To start the server, run: rails server
pause




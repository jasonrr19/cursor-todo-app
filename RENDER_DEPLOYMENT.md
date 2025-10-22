# 🚀 Deploying Cinema List Derby to Render.com

## Prerequisites

✅ GitHub account
✅ Render.com account (free tier available)
✅ TMDB API key (you already have this)

---

## Step 1: Push to GitHub

### Initialize Git (if not already done)
```bash
git init
git add .
git commit -m "Initial commit - Ready for Render deployment"
```

### Create GitHub Repository
1. Go to https://github.com/new
2. Name: `cinema-list-derby` (or your preferred name)
3. Make it **Public** or **Private** (Render works with both)
4. **Don't** initialize with README/license (you already have code)
5. Click "Create repository"

### Push to GitHub
```bash
git remote add origin https://github.com/YOUR_USERNAME/cinema-list-derby.git
git branch -M main
git push -u origin main
```

---

## Step 2: Deploy on Render

### A. Sign Up/Login to Render
1. Go to https://render.com
2. Sign up with your GitHub account (easiest way)
3. Authorize Render to access your repositories

### B. Create New Web Service
1. Click **"New +"** button in top right
2. Select **"Web Service"**
3. Connect your `cinema-list-derby` repository
4. Click **"Connect"**

### C. Configure the Service

Render will auto-detect it's a Rails app. Configure these settings:

**Basic Settings:**
- **Name:** `cinema-list-derby` (or your choice)
- **Region:** Choose closest to you
- **Branch:** `main`
- **Root Directory:** (leave blank)
- **Environment:** `Ruby`
- **Build Command:** `./bin/render-build.sh`
- **Start Command:** `bundle exec puma -C config/puma.rb`

**Instance Type:**
- Select **"Free"** (for demo/testing)
- Note: Free tier sleeps after 15 min of inactivity

### D. Add Environment Variables

Click **"Advanced"** and add these environment variables:

1. **RAILS_MASTER_KEY**
   - Value: (get from `config/master.key` file)
   - To see it: `cat config/master.key`

2. **TMDB_API_KEY**
   - Value: Your TMDB API key
   - Same one you're using locally

3. **RAILS_ENV**
   - Value: `production`
   - (This should auto-populate)

### E. Create Database

1. Click **"New +"** → **"PostgreSQL"**
2. **Name:** `cinema-list-derby-db`
3. **Database:** `cinema_list_derby_production`
4. **User:** `cinema_list_derby`
5. **Region:** Same as your web service
6. **Plan:** **Free** tier
7. Click **"Create Database"**

### F. Link Database to Web Service

1. Go back to your web service settings
2. Find **"Environment Variables"** section
3. Add new variable:
   - **Key:** `DATABASE_URL`
   - **Value:** Click "Add from Database" → Select your PostgreSQL database

### G. Deploy!

1. Click **"Create Web Service"**
2. Render will:
   - Clone your repository
   - Install dependencies
   - Run migrations
   - Seed the database
   - Start the server

⏱️ First deploy takes 5-10 minutes

---

## Step 3: Access Your Live Site

Once deployed, you'll get a URL like:
```
https://cinema-list-derby.onrender.com
```

🎉 **Your app is now live on the internet!**

---

## Important Files Created

✅ `render.yaml` - Render service configuration
✅ `bin/render-build.sh` - Build script for deployment
✅ Updated `Gemfile` - PostgreSQL for production
✅ Updated `config/database.yml` - PostgreSQL config

---

## Troubleshooting

### Build Fails
- Check build logs in Render dashboard
- Verify `RAILS_MASTER_KEY` is set correctly
- Ensure `bin/render-build.sh` is executable

### Database Connection Errors
- Verify `DATABASE_URL` is linked to your PostgreSQL database
- Check database is in the same region as web service

### App Loads but No Data
- Check if seed script ran successfully in build logs
- May need to manually run: `bundle exec rails db:seed` from Render Shell

### Free Tier Limitations
- App sleeps after 15 minutes of inactivity
- First request after sleep takes ~30 seconds to wake up
- 750 hours/month free (enough for constant uptime)

---

## Post-Deployment

### Manual Commands (if needed)

Access Render Shell:
1. Go to your service dashboard
2. Click **"Shell"** tab
3. Run commands:

```bash
# Reset and re-seed database
bundle exec rails db:reset

# Run migrations only
bundle exec rails db:migrate

# Seed data only
bundle exec rails db:seed

# Open Rails console
bundle exec rails console
```

### Updating Your App

After making changes locally:

```bash
git add .
git commit -m "Description of changes"
git push origin main
```

Render will automatically rebuild and redeploy! 🚀

---

## Monitoring

### View Logs
- Go to Render dashboard → Your service → **"Logs"** tab
- Real-time streaming logs
- Filter by type (Deploy, Runtime, etc.)

### Check Status
- Dashboard shows: **"Live"** (green) or errors (red)
- Response times and resource usage

---

## Cost

**Free Tier Includes:**
- ✅ 750 hours/month web service
- ✅ Free PostgreSQL (90 days, then expires)
- ✅ Automatic HTTPS
- ✅ Custom domains
- ✅ Unlimited deploys

**Paid Options** (if you need them later):
- $7/month - Persistent web service (no sleep)
- $7/month - Persistent PostgreSQL database

---

## Share Your URL!

Once deployed, share:
```
https://your-app-name.onrender.com
```

Or add a custom domain in Render settings!

---

## Need Help?

- **Render Docs:** https://render.com/docs
- **Rails on Render Guide:** https://render.com/docs/deploy-rails
- **Support:** help@render.com

---

✅ **You're all set! Your Cinema List Derby app is now on the internet!** 🎬✨


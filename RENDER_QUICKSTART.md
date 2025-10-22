# 🚀 Render Deployment - Quick Reference Card

## ⚡ Critical Information You'll Need

### 1. Rails Master Key (for Render)
```
30095a3c8c5be0576dd8174b80cf4a35
```
**⚠️ SAVE THIS! You'll need it when configuring Render environment variables.**

### 2. TMDB API Key
Your existing TMDB API key (same one you're using locally)

---

## 📝 Quick Deployment Checklist

### Step 1: Push to GitHub (5 minutes)
```bash
# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Ready for Render deployment"

# Add your GitHub repo as remote
git remote add origin https://github.com/YOUR_USERNAME/cinema-list-derby.git

# Push to GitHub
git push -u origin main
```

### Step 2: Sign Up for Render (2 minutes)
1. Go to: https://render.com
2. Click "Get Started for Free"
3. Sign up with GitHub account
4. Authorize Render to access your repos

### Step 3: Create Web Service (3 minutes)
1. Dashboard → Click **"New +"** → **"Web Service"**
2. Connect your `cinema-list-derby` repository
3. Click **"Connect"**
4. Configure:
   - **Name:** `cinema-list-derby`
   - **Region:** Choose closest to you
   - **Branch:** `main`
   - **Environment:** Ruby
   - **Build Command:** `./bin/render-build.sh`
   - **Start Command:** `bundle exec puma -C config/puma.rb`
   - **Instance Type:** Free

### Step 4: Add Environment Variables (2 minutes)
Click **"Advanced"** → Add these environment variables:

| Variable Name | Value |
|--------------|-------|
| `RAILS_MASTER_KEY` | `30095a3c8c5be0576dd8174b80cf4a35` |
| `TMDB_API_KEY` | (Your TMDB API key) |
| `RAILS_ENV` | `production` |

### Step 5: Create Database (3 minutes)
1. Dashboard → Click **"New +"** → **"PostgreSQL"**
2. Configure:
   - **Name:** `cinema-list-derby-db`
   - **Database:** `cinema_list_derby_production`
   - **User:** `cinema_list_derby`
   - **Region:** Same as web service
   - **Plan:** Free
3. Click **"Create Database"**

### Step 6: Link Database to Web Service (1 minute)
1. Go back to your web service settings
2. **Environment Variables** section
3. Add new variable:
   - **Key:** `DATABASE_URL`
   - **Value:** Click "Add from Database" → Select `cinema-list-derby-db`

### Step 7: Deploy! (5-10 minutes)
1. Click **"Create Web Service"**
2. Watch the build logs
3. Wait for "Live" status
4. Click your URL!

---

## 🎉 Your Live URL
```
https://cinema-list-derby.onrender.com
```
(or whatever name you chose)

---

## 🔧 Troubleshooting

### Build Fails?
- Check `RAILS_MASTER_KEY` is correct
- Check `TMDB_API_KEY` is set
- View build logs for specific error

### Database Connection Error?
- Verify `DATABASE_URL` is linked to PostgreSQL database
- Check database and web service are in same region

### App Loads But No Data?
- Check build logs to see if seed ran successfully
- May need to run manually from Render Shell:
  ```bash
  bundle exec rails db:seed
  ```

---

## 📱 Sharing Your App

Once deployed, share this URL with anyone:
```
https://cinema-list-derby.onrender.com
```

**Note:** Free tier sleeps after 15 min of inactivity. First request after sleep takes ~30 seconds to wake up.

---

## 🔄 Updating Your App

After making changes locally:
```bash
git add .
git commit -m "Description of changes"
git push origin main
```

Render will automatically rebuild and redeploy! 🚀

---

## 💰 Free Tier Details

- ✅ 750 hours/month web service (enough for 24/7 uptime)
- ✅ PostgreSQL database (free for 90 days)
- ✅ Automatic HTTPS
- ✅ Unlimited deployments
- ⚠️ App sleeps after 15 min inactivity

---

## 📚 Full Documentation

For detailed instructions, see: **RENDER_DEPLOYMENT.md**

---

## ✅ What's Already Done

✅ `render.yaml` - Render configuration
✅ `bin/render-build.sh` - Build script
✅ `Gemfile` - PostgreSQL for production
✅ `config/database.yml` - PostgreSQL config
✅ `.gitignore` - Protects sensitive files
✅ `config/master.key` - Generated and saved

---

## 🎯 You're Ready!

All configuration is complete. Just follow the 7 steps above!

**Total Time: ~15-20 minutes**

Good luck! 🚀✨


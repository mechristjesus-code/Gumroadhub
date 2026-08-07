# Termux: Local Notifications & Automated Backups Guide

## Overview

This guide shows you how to set up **local notifications** and **automated backups** for your Gumroad Creator Hub running on Termux. Everything runs locally on your phone with no external dependencies.

---

## Part 1: Setting Up Local Notifications

### Prerequisites

```bash
# Install required packages
pkg install termux-api termux-notification -y
```

### Enable Termux API

1. Install **Termux:API** app from F-Droid or GitHub
2. Grant permissions when prompted
3. Verify installation:
   ```bash
   termux-notification --title "Test" --content "Notifications working!"
   ```

### Types of Notifications

#### Simple Notification
```bash
termux-notification \
  --title "Creator Hub" \
  --content "Your backup is complete"
```

#### High Priority Alert
```bash
termux-notification \
  --title "Alert" \
  --content "App offline" \
  --priority high
```

#### With Action Button
```bash
termux-notification \
  --title "Creator Hub" \
  --content "New sale recorded" \
  --action "open_app"
```

#### Notification with Sound
```bash
termux-notification \
  --title "Creator Hub" \
  --content "Important update" \
  --priority high \
  --sound
```

---

## Part 2: Automated Backups

### Quick Setup (5 minutes)

```bash
# 1. Navigate to your app directory
cd ~/Gumroadhub

# 2. Make the backup script executable
chmod +x termux-backup-auto.sh

# 3. Run the setup wizard
./termux-backup-auto.sh
```

### Menu Options

| Option | Function |
| :--- | :--- |
| 1 | Perform Backup Now |
| 2 | Setup Automated Daily Backups |
| 3 | Check App Health |
| 4 | Start App |
| 5 | View Recent Backups |
| 6 | View Logs |
| 7 | Send Test Notification |

### Backup Schedule

The automated backup runs:
- **Time**: 2:00 AM daily
- **Location**: `~/storage/downloads/CreatorHub-Backups/`
- **Retention**: Keeps last 7 backups
- **Notification**: Sends notification on completion

### Manual Backup

```bash
# Backup now
./termux-backup-auto.sh
# Select option 1

# View backups
ls ~/storage/downloads/CreatorHub-Backups/
```

---

## Part 3: Advanced Setup

### Cron Jobs (Background Scheduling)

#### View Current Cron Jobs
```bash
crontab -l
```

#### Edit Cron Schedule
```bash
crontab -e
```

#### Common Cron Patterns

| Pattern | Description |
| :--- | :--- |
| `0 2 * * *` | Daily at 2:00 AM |
| `0 */6 * * *` | Every 6 hours |
| `0 0 * * 0` | Weekly (Sunday at midnight) |
| `0 0 1 * *` | Monthly (1st of month) |

#### Custom Backup Schedule

Edit your crontab:
```bash
crontab -e
```

Add one of these lines:

**Backup every 6 hours:**
```
0 */6 * * * /data/data/com.termux/files/home/.creator-hub-cron.sh
```

**Backup twice daily (6 AM & 6 PM):**
```
0 6,18 * * * /data/data/com.termux/files/home/.creator-hub-cron.sh
```

**Backup every hour:**
```
0 * * * * /data/data/com.termux/files/home/.creator-hub-cron.sh
```

### Health Checks

The backup script automatically:
- Checks if the app is running
- Restarts the app if needed
- Sends alerts if something fails
- Logs all activities

View logs:
```bash
tail -f ~/.creator-hub-backup.log
```

---

## Part 4: Backup Management

### Backup Location

```
~/storage/downloads/CreatorHub-Backups/
```

### Backup File Format

```
backup_20260807_143022.json
```

### Restore from Backup

1. Open your app: `http://localhost:8080/admin-offline.html`
2. Go to **Backup & Sync** section
3. Select the backup file
4. Tap **Import**

### Export Backups to Cloud

```bash
# Copy to Google Drive (if installed)
cp ~/storage/downloads/CreatorHub-Backups/backup_*.json \
   ~/storage/shared/GoogleDrive/

# Or upload manually via file manager
```

---

## Part 5: Notification Automation

### Send Notification on Backup

The script automatically sends notifications:

```bash
# On successful backup
"Backup saved: 2.5 MB"

# On failure
"Backup failed - Check logs"

# On app start
"App is now running"
```

### Custom Notifications

Create a notification script:

```bash
#!/bin/bash
# ~/notify-sale.sh

termux-notification \
  --title "🎉 New Sale!" \
  --content "Product: $1, Amount: $2" \
  --priority high \
  --sound
```

Run it:
```bash
./notify-sale.sh "My Course" "$49.99"
```

### Notification from Web App

Add this to your admin panel to trigger notifications:

```javascript
// Send notification from web app
function sendNotification(title, message) {
  fetch('http://localhost:8080/api/notify', {
    method: 'POST',
    body: JSON.stringify({ title, message })
  });
}

// Example: Notify on sale
sendNotification("New Sale!", "You earned $49.99");
```

---

## Part 6: Troubleshooting

### Notifications Not Working

**Problem**: No notifications appear

**Solution**:
```bash
# 1. Check if Termux:API is installed
pkg list-installed | grep termux-api

# 2. Reinstall if needed
pkg install termux-api termux-notification -y

# 3. Test notification
termux-notification --title "Test" --content "Works?"
```

### Backups Not Running

**Problem**: Cron jobs not executing

**Solution**:
```bash
# 1. Check cron status
crontab -l

# 2. View cron logs
tail -f ~/.creator-hub-backup.log

# 3. Manually run backup
./termux-backup-auto.sh
```

### App Not Starting

**Problem**: Backup script can't start the app

**Solution**:
```bash
# 1. Start manually
cd ~/Gumroadhub
python3 -m http.server 8080

# 2. Check if port 8080 is in use
netstat -tuln | grep 8080

# 3. Use different port
python3 -m http.server 8081
```

### Storage Full

**Problem**: Backups taking too much space

**Solution**:
```bash
# 1. Check storage
du -sh ~/storage/downloads/CreatorHub-Backups/

# 2. Delete old backups manually
rm ~/storage/downloads/CreatorHub-Backups/backup_old_*.json

# 3. Compress backups
tar -czf backups.tar.gz ~/storage/downloads/CreatorHub-Backups/
```

---

## Part 7: Best Practices

### Backup Strategy

1. **Daily Backups**: Automated at 2 AM
2. **Weekly Export**: Manual export to cloud
3. **Monthly Archive**: Compress and store offline
4. **Multiple Copies**: Keep backups in 2+ locations

### Notification Best Practices

1. **Important Events Only**: Backup completion, errors, sales
2. **Avoid Spam**: Don't notify for every action
3. **Use Priority Levels**: High for alerts, default for info
4. **Include Context**: Always include relevant details

### Performance Tips

1. **Limit Backup Frequency**: Once daily is usually enough
2. **Compress Old Backups**: Save storage space
3. **Archive Regularly**: Move old backups to cloud
4. **Clean Logs**: Rotate logs monthly

---

## Summary

| Feature | Status | Command |
| :--- | :--- | :--- |
| **Local Notifications** | ✅ Ready | `termux-notification` |
| **Automated Backups** | ✅ Ready | `./termux-backup-auto.sh` |
| **Cron Scheduling** | ✅ Ready | `crontab -e` |
| **Health Checks** | ✅ Ready | Automatic |
| **Log Monitoring** | ✅ Ready | `tail -f ~/.creator-hub-backup.log` |

Your Creator Hub is now fully automated and notified! 🚀

#!/bin/bash
# Gumroad Creator Hub - Automated Backup & Notification Script for Termux
# Runs scheduled backups and sends local notifications
# Install: chmod +x termux-backup-auto.sh && ./termux-backup-auto.sh

BACKUP_DIR="$HOME/storage/downloads/CreatorHub-Backups"
APP_DIR="$HOME/Gumroadhub"
LOG_FILE="$HOME/.creator-hub-backup.log"
BACKUP_INTERVAL=86400  # 24 hours in seconds

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Send notification using termux-notification
send_notification() {
    local title=$1
    local message=$2
    local priority=${3:-"default"}  # default, high, low
    
    if command -v termux-notification &> /dev/null; then
        termux-notification \
            --title "$title" \
            --content "$message" \
            --priority "$priority" \
            --action "open_app"
        log "Notification sent: $title - $message"
    else
        log "WARNING: termux-notification not available. Install: pkg install termux-api termux-notification"
    fi
}

# Perform backup
perform_backup() {
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_file="$BACKUP_DIR/backup_$timestamp.json"
    
    log "Starting backup..."
    
    # Create backup JSON with data from localStorage
    # This will be called from the web app via fetch
    curl -s "http://localhost:8080/api/export" > "$backup_file" 2>/dev/null
    
    if [ $? -eq 0 ] && [ -s "$backup_file" ]; then
        local file_size=$(du -h "$backup_file" | cut -f1)
        log "✓ Backup completed: $backup_file ($file_size)"
        send_notification "Creator Hub Backup" "Backup saved: $file_size" "default"
        
        # Keep only last 7 backups
        cleanup_old_backups
        return 0
    else
        log "✗ Backup failed"
        send_notification "Creator Hub Backup Failed" "Check logs for details" "high"
        return 1
    fi
}

# Clean up old backups (keep last 7)
cleanup_old_backups() {
    local backup_count=$(ls -1 "$BACKUP_DIR"/backup_*.json 2>/dev/null | wc -l)
    
    if [ $backup_count -gt 7 ]; then
        log "Cleaning up old backups (keeping 7 most recent)..."
        ls -1t "$BACKUP_DIR"/backup_*.json | tail -n +8 | xargs rm -f
        log "Cleanup completed"
    fi
}

# Monitor app health
check_app_health() {
    if curl -s "http://localhost:8080/admin-offline.html" > /dev/null; then
        log "✓ App is running and healthy"
        return 0
    else
        log "✗ App is not responding"
        send_notification "Creator Hub Alert" "App not responding" "high"
        return 1
    fi
}

# Start the app if not running
start_app() {
    if ! curl -s "http://localhost:8080" > /dev/null 2>&1; then
        log "Starting app..."
        cd "$APP_DIR"
        python3 -m http.server 8080 > /dev/null 2>&1 &
        sleep 2
        send_notification "Creator Hub Started" "App is now running" "default"
    fi
}

# Setup cron job for automated backups
setup_cron() {
    local cron_cmd="$HOME/.creator-hub-cron.sh"
    
    cat > "$cron_cmd" << 'EOF'
#!/bin/bash
source "$HOME/.creator-hub-backup.sh"
perform_backup
check_app_health
EOF
    
    chmod +x "$cron_cmd"
    
    # Add to crontab (runs every 24 hours at 2 AM)
    (crontab -l 2>/dev/null | grep -v "creator-hub"; echo "0 2 * * * $cron_cmd") | crontab -
    
    log "Cron job scheduled for daily backups at 2 AM"
}

# Display menu
show_menu() {
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║   Gumroad Creator Hub - Backup & Notification Setup    ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    echo "1) Perform Backup Now"
    echo "2) Setup Automated Daily Backups"
    echo "3) Check App Health"
    echo "4) Start App"
    echo "5) View Recent Backups"
    echo "6) View Logs"
    echo "7) Send Test Notification"
    echo "8) Exit"
    echo ""
    read -p "Choose an option (1-8): " choice
}

# Main loop
main() {
    log "Gumroad Creator Hub - Backup & Notification Manager"
    
    # Check dependencies
    if ! command -v python3 &> /dev/null; then
        log "ERROR: Python3 not found. Install: pkg install python3"
        exit 1
    fi
    
    while true; do
        show_menu
        
        case $choice in
            1)
                perform_backup
                ;;
            2)
                setup_cron
                ;;
            3)
                check_app_health
                ;;
            4)
                start_app
                ;;
            5)
                echo ""
                echo "Recent Backups:"
                ls -lht "$BACKUP_DIR"/backup_*.json 2>/dev/null | head -10
                ;;
            6)
                echo ""
                echo "Recent Logs:"
                tail -20 "$LOG_FILE"
                ;;
            7)
                send_notification "Test Notification" "Creator Hub is working!" "default"
                ;;
            8)
                log "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid option"
                ;;
        esac
    done
}

# Run main function
main

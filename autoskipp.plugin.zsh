#!/bin/zsh

# AutoSkipp - Automatic countdown and skip functionality for Claude Code
# Independent Oh My Zsh plugin

# Main ... function with countdown (reticências = skipping part of the story)
...() {
    local countdown_time=5
    local message="Skipping in"
    local auto_mode=false
    local help_mode=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skiptime|-t)
                countdown_time="$2"
                shift 2
                ;;
            --message|-m)
                message="$2"
                shift 2
                ;;
            --auto|-a)
                auto_mode=true
                shift
                ;;
            --help|-h)
                help_mode=true
                shift
                ;;
            *)
                echo "Unknown option: $1"
                help_mode=true
                shift
                ;;
        esac
    done
    
    # Show help
    if [[ "$help_mode" == true ]]; then
        echo "... - AutoSkipp (reticências = skipping part of the story)"
        echo ""
        echo "USAGE:"
        echo "  ...                           # 5 second default countdown"
        echo "  ... --skiptime 10             # Custom countdown time"  
        echo "  ... --message \"Loading\"       # Custom message"
        echo "  ... --auto                    # Only run if Claude Code detected"
        echo "  ... --help                    # Show this help"
        echo ""
        echo "ALIASES:"
        echo "  -t, --skiptime    Countdown time in seconds"
        echo "  -m, --message     Custom countdown message"  
        echo "  -a, --auto        Auto-detect Claude Code first"
        echo "  -h, --help        Show help"
        return 0
    fi
    
    # Auto-detect mode
    if [[ "$auto_mode" == true ]]; then
        if ! _autoskipp_detect_claude; then
            echo "❌ Claude Code not detected - skipping AutoSkipp"
            return 1
        fi
        echo "🔍 Claude Code detected!"
    fi
    
    echo "🤖 AutoSkipp activated - $message $countdown_time seconds..."
    
    # Countdown with progress bar
    for ((i=$countdown_time; i>0; i--)); do
        local progress_bar=""
        local filled=$((($countdown_time - $i + 1) * 20 / $countdown_time))
        
        for ((j=1; j<=20; j++)); do
            if [[ $j -le $filled ]]; then
                progress_bar+="█"
            else
                progress_bar+="░"
            fi
        done
        
        printf "\r⏰ [$progress_bar] %d seconds remaining" $i
        sleep 1
    done
    
    printf "\n✅ AutoSkipp completed!\n"
    
    # Auto-send "yes" if Claude Code is detected
    _autoskipp_send_response
}

# Detect if Claude Code is running and send response
_autoskipp_send_response() {
    if _autoskipp_detect_claude; then
        echo "🎯 Claude Code detected - sending automated response..."
        # Send "yes" via AppleScript (macOS) or similar
        if [[ "$OSTYPE" == "darwin"* ]]; then
            osascript -e 'tell application "System Events" to keystroke "yes"'
            osascript -e 'tell application "System Events" to key code 36' # Enter key
        fi
    fi
}

# Detect Claude Code process
_autoskipp_detect_claude() {
    if command -v pgrep &> /dev/null; then
        pgrep -f "claude" > /dev/null
    else
        ps aux | grep -i claude | grep -v grep > /dev/null
    fi
}

# Auto-start autoskipp when Claude Code is detected
auto() {
    if _autoskipp_detect_claude; then
        echo "🔍 Claude Code detected - starting AutoSkipp..."
        ... $@
    else
        echo "❌ Claude Code not detected"
    fi
}

# Quick aliases
alias ask="..."
alias skip="... 3"
alias quick="... 1"

# Hook into command execution to auto-detect
autoload -U add-zsh-hook
_autoskipp_preexec() {
    if [[ $1 =~ "claude" ]]; then
        echo "🤖 Claude command detected - AutoSkipp ready!"
    fi
}
add-zsh-hook preexec _autoskipp_preexec

echo "✨ AutoSkipp plugin loaded! Use '...', 'ask', 'skip', or 'auto'"
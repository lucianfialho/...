# dotdotdot

**Automatic countdown and skip functionality** - *reticências = skipping part of the story*

A universal command-line tool that works across all shells (bash, zsh, fish) for automating repetitive interactions with visual countdown and progress bars.

## Installation

### One-Line Installation

```bash
curl -fsSL https://raw.githubusercontent.com/lucianfialho/.../main/install.sh | bash
```

### Manual Installation 

```bash
# Download and install
curl -fsSL https://raw.githubusercontent.com/lucianfialho/.../main/dotdotdot -o /usr/local/bin/dotdotdot
chmod +x /usr/local/bin/dotdotdot

# Optional: Create alias
echo 'alias ...=dotdotdot' >> ~/.zshrc  # or ~/.bashrc
source ~/.zshrc
```

## Usage

### Command Line Interface

```bash
dotdotdot                              # Default 5-second countdown
dotdotdot --skiptime 3                 # Custom countdown time
dotdotdot --message "Loading"          # Custom message
dotdotdot --auto                       # Only run if Claude Code detected
dotdotdot --help                       # Show help
```

### Short Flags

```bash
dotdotdot -t 10                        # --skiptime 10
dotdotdot -m "Waiting"                 # --message "Waiting"
dotdotdot -a                           # --auto
dotdotdot -h                           # --help
```

### With Alias (Recommended)

After installing, add alias to your shell config:
```bash
alias ...=dotdotdot
```

Then use the elegant syntax:
```bash
...                              # Default 5-second countdown  
... --skiptime 3                 # Custom countdown
... -t 10 -m "Loading"          # Combined flags
... --auto                       # Auto-detect mode
```

## Features

- 🎯 **Universal**: Works in bash, zsh, fish, and any POSIX shell
- ⏰ **Visual Countdown**: Beautiful progress bar with countdown timer
- 🤖 **Auto Detection**: Detects Claude Code processes automatically  
- 🎨 **Colored Output**: Rich terminal colors for better UX
- ⚡ **Fast**: Lightweight bash script with no dependencies
- 🔧 **Flexible**: Customizable countdown time and messages
- 📦 **Easy Install**: One-line installation script

## Platform Support

- **macOS**: Full support with AppleScript automation
- **Linux**: Full support with basic automation
- **Windows**: Basic countdown functionality (via WSL/Git Bash)

## Examples

```bash
# Basic usage
dotdotdot
...                              # With alias

# Custom countdown  
dotdotdot --skiptime 7
... -t 7

# Custom message
dotdotdot --message "Deploying" --skiptime 10
... -m "Deploying" -t 10

# Auto-detect Claude Code
dotdotdot --auto
... -a

# Combined flags
dotdotdot --skiptime 15 --message "Building project" --auto
... -t 15 -m "Building project" -a
```

## How It Works

1. **Process Detection**: Scans running processes for Claude Code
2. **Visual Countdown**: Shows progress bar with remaining time
3. **Auto Response**: Sends automated responses via system APIs (macOS)
4. **Universal Shell**: Works across bash, zsh, fish without dependencies

Perfect for automating repetitive CLI interactions with style! 🚀

## Philosophy

The name `dotdotdot` represents the concept of **reticências** (ellipsis) - literally "skipping part of the story." When you use `...` in writing, you're jumping over details to get to the point. This tool does the same for your command line interactions.

---

*Made with ❤️ for developers who value their time*
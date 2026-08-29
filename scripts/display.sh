#!/bin/bash

# Display Configuration Script
# Detects and configures monitors with optimal settings

echo "🖥️  Display Configuration"
echo "========================"

# Check if NVIDIA drivers are loaded
if ! command -v nvidia-smi &> /dev/null; then
    echo "⚠️  NVIDIA drivers not found or not loaded"
    echo "Run: sudo ubuntu-drivers install && reboot"
    exit 1
fi

# Display detected monitors
echo ""
echo "Detected Displays:"
xrandr --query | grep " connected" || {
    echo "❌ No displays detected!"
    exit 1
}

echo ""
echo "Available configurations:"
echo "1. Auto-configure all displays (recommended)"
echo "2. Show detailed display information"
echo "3. Reset to default"
echo ""
read -p "Choose option (1-3): " choice

case $choice in
    1)
        echo "🔧 Auto-configuring displays..."
        # This will auto-arrange displays and set highest refresh rates
        xrandr --auto
        
        # Get all connected outputs
        outputs=($(xrandr | grep " connected" | awk '{print $1}'))
        
        # Set highest refresh rate for each display
        for output in "${outputs[@]}"; do
            # Get highest available resolution and refresh rate
            best=$(xrandr | grep -A 20 "^${output}" | grep -v "^${output}" | head -n 1 | awk '{print $1, $2}' | sed 's/+//')
            if [ -n "$best" ]; then
                resolution=$(echo $best | awk '{print $1}')
                refresh=$(echo $best | awk '{print $2}')
                echo "  Setting $output to ${resolution} @ ${refresh}"
                xrandr --output "$output" --mode "$resolution" --rate "${refresh/Hz/}" 2>/dev/null || true
            fi
        done
        
        echo "✅ Display configuration complete!"
        echo ""
        xrandr --query | grep " connected" -A 1
        ;;
    2)
        echo ""
        xrandr --verbose | more
        ;;
    3)
        echo "🔄 Resetting to defaults..."
        xrandr --auto
        echo "✅ Reset complete!"
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac

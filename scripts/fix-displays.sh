#!/bin/bash

# Quick display fix script
# Run this after switching cables or rebooting from Windows

echo "🔧 Fixing display configuration..."

# Restart display manager to re-detect monitors
if systemctl is-active --quiet gdm; then
    echo "Restarting GDM display manager..."
    sudo systemctl restart gdm
elif systemctl is-active --quiet lightdm; then
    echo "Restarting LightDM display manager..."
    sudo systemctl restart lightdm
elif systemctl is-active --quiet sddm; then
    echo "Restarting SDDM display manager..."
    sudo systemctl restart sddm
else
    # If no display manager, just reset xrandr
    echo "Resetting display configuration..."
    xrandr --auto
    
    # Force NVIDIA to re-detect
    if command -v nvidia-settings &> /dev/null; then
        nvidia-settings --query all > /dev/null 2>&1
    fi
fi

echo "✅ Display manager restarted. Please log back in."

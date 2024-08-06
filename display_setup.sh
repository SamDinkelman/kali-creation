#!/bin/bash
echo "Configuring display settings for high-resolution monitor in XFCE..."

# Set resolution (adjust as needed)
xrandr --output $(xrandr | grep " connected" | cut -f1 -d " ") --mode 3538x1931

# Set DPI in .Xresources
if ! grep -q "Xft.dpi:" ~/.Xresources; then
    echo "Xft.dpi: 168" >> ~/.Xresources
else
    sed -i 's/^Xft.dpi:.*/Xft.dpi: 168/' ~/.Xresources
fi
xrdb -merge ~/.Xresources

# Configure XFCE settings
xfconf-query -c xsettings -p /Xft/DPI -n -t int -s 120
xfconf-query -c xfwm4 -p /general/theme -n -t string -s Kali-Dark
xfconf-query -c xsettings -p /Gtk/CursorThemeSize -n -t int -s 30
xfconf-query -c xsettings -p /Gtk/FontName -n -t string -s "Sans 12"

# Adjust GTK theme settings
mkdir -p ~/.config/gtk-3.0
cat << EOF > ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Kali-Dark
gtk-font-name=Sans 12
gtk-cursor-theme-size=48
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
EOF

# Set Qt and GDK scaling
for file in ~/.profile ~/.xprofile; do
    if [ -f "$file" ]; then
        # Remove existing QT and GDK scale settings
        sed -i '/QT_AUTO_SCREEN_SCALE_FACTOR/d' "$file"
        sed -i '/QT_SCALE_FACTOR/d' "$file"
        sed -i '/GDK_SCALE/d' "$file"
        sed -i '/GDK_DPI_SCALE/d' "$file"
        
        # Add new settings
        echo "export QT_AUTO_SCREEN_SCALE_FACTOR=1" >> "$file"
        echo "export QT_SCALE_FACTOR=1.3" >> "$file"
        echo "export GDK_SCALE=1" >> "$file"
        echo "export GDK_DPI_SCALE=1.1" >> "$file"
    fi
done

# Additional XFCE-specific settings
xfconf-query -c xfce4-desktop -p /desktop-icons/icon-size -n -t int -s 48
xfconf-query -c xfce4-panel -p /panels/panel-1/size -n -t int -s 42

echo "Display settings configured. You need to log out and log back in for all changes to take effect."

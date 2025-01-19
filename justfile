cwd := `pwd`
theme := "MyTheme" # default theme

init:
    #!/usr/bin/env bash
    # if theme is not set, prompt for theme name
    if [ -z {{theme}} ]; then
        echo "Theme is not set, please set a theme name in the justfile"
        exit 1
    fi
    
    # Create main theme directory
    mkdir -p "Configs/.config/hyde/themes/$theme/wallpapers"
    
    # Create other required directories
    mkdir -p "Source/arcs"
    mkdir -p "screenshots"
    mkdir -p "refs"
    
    echo "Theme structure initialized for: $theme"
    echo "Created directories:"
    echo "- Configs/.config/hyde/themes/$theme/wallpapers"
    echo "- Source/arcs"
    echo "- screenshots"

install:
    # delete existing theme
    rm -rf ~/.config/hyde/themes/{{theme}}
    # Run the Hyde theme import command with the current working directory
    env FORCE_THEME_UPDATE=true Hyde theme import "{{theme}}" "{{cwd}}"
    # BUG: sometimes when imported locally, Configs folder is not copied over
    mkdir -p ~/.config/hyde/themes/{{theme}}
    cp -r Configs/.config/hyde/themes/{{theme}}/. ~/.config/hyde/themes/{{theme}}/.
gen-dcol:
    echo "Copying main dcol from current wallpaper to ./refs"
    cp $HOME/.cache/hyde/wall.dcol {{cwd}}/refs/theme.dcol
    echo "Dcol files copied to {{cwd}}/refs/theme.dcol"   
gen-gtk4:
    echo "Copying GTK4 files from wallbash to your theme in ./refs"
    mkdir -p {{cwd}}/refs/gtk-4.0
    cp $HOME/.themes/Wallbash-Gtk/gtk-4.0/*.css {{cwd}}/refs/gtk-4.0/
    echo "GTK4 files copied to {{cwd}}/refs/gtk-4.0"
gen-hypr:
    echo "Copying Hyprland files from wallbash to your theme in ./refs"
    cp $HOME/.config/hypr/themes/colors.conf {{cwd}}/refs/hypr.theme
    echo '$HOME/.config/hypr/themes/theme.conf|> $HOME/.config/hypr/themes/colors.conf' | cat - {{cwd}}/refs/hypr.theme > temp && mv temp {{cwd}}/refs/hypr.theme
    echo "Hyprland wallbash theme copied to {{cwd}}/refs/hypr.theme"
gen-waybar:
    echo "Copying Waybar files from wallbash to your theme in ./refs"
    cp $HOME/.config/waybar/theme.css {{cwd}}/refs/waybar.theme
    echo '$HOME/.config/waybar/theme.css|${scrDir}/wbarconfgen.sh' | cat - {{cwd}}/refs/waybar.theme > temp && mv temp {{cwd}}/refs/waybar.theme
    echo "Waybar files copied to {{cwd}}/refs/waybar.theme"
gen-rofi:
    echo "Copying Rofi files from wallbash to your theme in ./refs"
    cp $HOME/.config/rofi/theme.rasi {{cwd}}/refs/rofi.theme
    echo '$HOME/.config/rofi/theme.rasi' | cat - {{cwd}}/refs/rofi.theme > temp && mv temp {{cwd}}/refs/rofi.theme
    echo "Rofi files copied to {{cwd}}/refs/rofi.theme"
gen-kvantum:
    echo "Copying Kvantum files from wallbash to your theme in ./refs"
    mkdir -p {{cwd}}/refs/kvantum
    cp $HOME/.config/Kvantum/wallbash/wallbash.svg {{cwd}}/refs/kvantum/kvantum.theme
    cp $HOME/.config/Kvantum/wallbash/wallbash.kvconfig {{cwd}}/refs/kvantum/kvconfig.theme
    echo '$HOME/.config/Kvantum/wallbash/wallbash.svg' | cat - {{cwd}}/refs/kvantum/kvantum.theme > temp && mv temp {{cwd}}/refs/kvantum/kvantum.theme
    echo '$HOME/.config/Kvantum/wallbash/wallbash.kvconfig' | cat - {{cwd}}/refs/kvantum/kvconfig.theme > temp && mv temp {{cwd}}/refs/kvantum/kvconfig.theme
    echo "Kvantum files copied to {{cwd}}/refs/kvantum"
gen-kitty:
    echo "Copying Kitty files from wallbash to your theme in ./refs"
    cp $HOME/.config/kitty/theme.conf {{cwd}}/refs/kitty.theme
    echo '$HOME/.config/kitty/theme.conf|killall -SIGUSR1 kitty' | cat - {{cwd}}/refs/kitty.theme > temp && mv temp {{cwd}}/refs/kitty.theme
    echo "Kitty files copied to {{cwd}}/refs/kitty.theme"
gen-all:
    just gen-dcol
    just gen-gtk4
    just gen-hypr
    just gen-waybar
    just gen-rofi
    just gen-kvantum
    just gen-kitty

reset:
    # prompt for confirmation
    read -p "Are you sure you want to reset the theme structure? This will delete all your current theme files. (y/n): " confirm
    if [ "$confirm" != "y" ]; then
        echo "Reset cancelled"
        exit 1
    fi

    rm -rf ./Configs
    rm -rf ./Source
    rm -rf ./screenshots

    echo "Theme structure reset, `just init` to reinitialize"


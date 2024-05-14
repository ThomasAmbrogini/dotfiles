[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# Command to set the wallpaper
~/.fehbg &

xrandr --auto --output DP1 --right-of eDP1

exec i3


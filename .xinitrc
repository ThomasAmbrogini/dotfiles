[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# Command to set the wallpaper
~/.fehbg &

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

xrandr --auto --output DP1 --right-of eDP1

exec i3


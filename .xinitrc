[ -f "$HOME/.Xmodmap" ] && xmodmap "$HOME/.Xmodmap"

# Command to set the wallpaper
~/.fehbg &

[ -f "$HOME/.Xresources" ] &&  xrdb -merge "$HOME/.Xresources"

xrandr --auto --output DP1 --left-of eDP1

exec i3


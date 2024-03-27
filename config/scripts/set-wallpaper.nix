{ pkgs }:

pkgs.writeShellScriptBin "set-wallpaper" ''
# icon: (field_name)\0icon\x1f(path_to_icon)\n
_SW_TRANSITION1="--transition-type wave --transition-angle 120 --transition-step 30"
_SW_TRANSITION2="--transition-type wipe --transition-angle 30 --transition-step 30"
_SW_TRANSITION3="--transition-type center --transition-step 30"
_SW_TRANSITION4="--transition-type outer --transition-pos 0.3,0.8 --transition-step 30"
_SW_TRANSITION5="--transition-type wipe --transition-angle 270 --transition-step 30"

_SW_WALLPAPER_PATH="$HOME/Pictures/Wallpapers"
_SW_LINES=$(ls -1 $_SW_WALLPAPER_PATH | wc -l)

# Custom array
files_with_name=()
files=()

for file in "$_SW_WALLPAPER_PATH"/*; do
    if [ -f "$file" ]; then
        files+=("$(basename "$file")")
	files_with_name+=("$(basename "$file")")
    fi
done

for ((i = 0; i < ${#files[@]}; i++)); do
  files[i]="${files[i]}\0icon\x1f$_SW_WALLPAPER_PATH/${files[i]}\n"
done

# Skibidi dop dop dop yes yes skibidi dop dop drrr drrr
chosen=$(echo -en "${files[@]}" |
  rofi -dmenu -p "󰸉 Wallpapers" -window-title "Wallpapers" -l $_SW_LINES -format i)

# Exit if none...
[ -z "$chosen" ] && exit

# Take transition
NUM=$(shuf -e 1 2 3 4 5 -n 1)
case $NUM in
  1)
    _SW_TRANSITION=$_SW_TRANSITION1
  ;;
  2)
    _SW_TRANSITION=$_SW_TRANSITION2
  ;;
  3)
    _SW_TRANSITION=$_SW_TRANSITION3
  ;;
  4)
    _SW_TRANSITION=$_SW_TRANSITION4
  ;;
  5)
    _SW_TRANSITION=$_SW_TRANSITION5
  ;;
esac

# Apply walpaper with 'swww'
swww img "$_SW_WALLPAPER_PATH/${files_with_name[$chosen]}" $_SW_TRANSITION
''

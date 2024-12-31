SLURP_OPT=(-b "#212121aa" -B "#212121aa" -c "#22ddeeee")

function freeze() {
    hyprpicker -r -z &
    sleep 0.2
    picker_pid=$!
    if ! "$@"; then
        kill $picker_pid
        exit 255
    else
        kill $picker_pid
    fi
}

function grab_region() {
    slurp -d "${SLURP_OPT[@]}"
}

function grab_window() {
    monitors=$(hyprctl -j monitors | jq -r 'map(.activeWorkspace.id) | join(",")')
    clients=$(hyprctl -j clients | jq -r "[.[] | select(.workspace.id | contains($monitors))]")
    boxes=$(echo "$clients" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1]) \(.title)"' | cut -f1,2 -d' ')
    1>&2 echo "$boxes"
    slurp -r "${SLURP_OPT[@]}" <<< "$boxes"
}

function grab_output() {
    slurp -or "${SLURP_OPT[@]}"
}

function grab_and_save() {
    local geometry
    if [[ "$1" != "" ]]; then
        geometry="-g $1"
    fi

    save_path="$HOME/Pictures/ScreenShot"
    file_name=$(date +'%Y%m%d_%H%M%S.png')
    mkdir -p "$save_path"
    grim "$geometry" "$save_path/$file_name"
    wl-copy --type image/png < "$save_path/$file_name"
    notify-send \
        -a Hyprshot \
        -i "$save_path/$file_name" \
        "Screenshot created" \
        "${file_name}"
}

function grab_and_copy() {
    local geometry
    if [[ "$1" != "" ]]; then
        geometry="-g $1"
    fi

    wl-copy --type image/png < <(grim "$geometry" -)
    notify-send \
        -a Hyprshot \
        "Screenshot created" \
        "Copy to clipboard"
}

# Usage: Hyprshot MODE [copy|save]
function main() {
    local geometry
    case "$1" in
        region)
            geometry=$(grab_region)
            ;;
        window)
            geometry=$(grab_window)
            ;;
        output)
            geometry=$(grab_output)
            ;;
        all)
            geometry=""
            ;;
        *)
            return
            ;;
    esac

    echo "main: grab -> $geometry"
    case "${2:-copy}" in
        save)
            grab_and_save "$geometry"
            ;;
        copy)
            grab_and_copy "$geometry"
            ;;
    esac
}

freeze main "$@"

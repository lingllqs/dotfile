#! /bin/bash
# DATE 获取日期和时间的脚本

tempfile=$(cd $(dirname $0);cd ..;pwd)/temp

this=_date
icon_color="^c#eeeeee^^b#2222220x88^"
text_color="^c#eeeeee^^b#2222220x99^"
signal=$(echo "^s$this^" | sed 's/_//')

update() {
    time_text="$(date '+%F %H:%M')"
    case "$(date '+%I')" in
        "01") time_icon="" ;;
        "02") time_icon="" ;;
        "03") time_icon="" ;;
        "04") time_icon="" ;;
        "05") time_icon="" ;;
        "06") time_icon="" ;;
        "07") time_icon="" ;;
        "08") time_icon="" ;;
        "09") time_icon="" ;;
        "10") time_icon="" ;;
        "11") time_icon="" ;;
        "12") time_icon="" ;;
    esac

    weekday=$(date +%w)
    case $weekday in
        0) day="星期日" ;;
        1) day="星期一" ;;
        2) day="星期二" ;;
        3) day="星期三" ;;
        4) day="星期四" ;;
        5) day="星期五" ;;
        6) day="星期六" ;;
    esac

    icon=" $time_icon "
    text=" $time_text $day "

    sed -i '/^export '$this'=.*$/d' $tempfile
    printf "export %s='%s%s%s%s%s'\n" $this "$signal" "$icon_color" "$icon" "$text_color" "$text" >> $tempfile
}

notify() {
    _cal=$(cal | sed 1,2d | sed 's/..7m/<b><span color="#fe32ff">/;s/..27m/<\/span><\/b>/')
    # _cal=$(cal --color=always | sed 1,2d)
    _todo=$(cat ~/.todo.md | sed 's/\(- \[x\] \)\(.*\)/<span color="#ff79c6">\1<s>\2<\/s><\/span>/' | sed 's/- \[[ |x]\] //')
    notify-send "  Calendar" "\n$_cal\n————————————————————\n$_todo" -r 9527
}

call_todo() {
    pid1=`ps aux | grep 'st -t statusutil' | grep -v grep | awk '{print $2}'`
    pid2=`ps aux | grep 'st -t statusutil_todo' | grep -v grep | awk '{print $2}'`
    mx=`xdotool getmouselocation --shell | grep X= | sed 's/X=//'`
    my=`xdotool getmouselocation --shell | grep Y= | sed 's/Y=//'`
    kill $pid1 && kill $pid2 || st -t statusutil_todo -g 50x15+$((mx - 200))+$((my + 20)) -c FGN -e nvim ~/.todo.md 
}

click() {
    case "$1" in
        L) notify ;;
        R) call_todo ;;
    esac
}

case "$1" in
    click) click $2 ;;
    notify) notify ;;
    *) update ;;
esac

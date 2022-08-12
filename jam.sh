#!/bin/bash
# Sync Jam otomatis berdasarkan bug isp by AlkhaNET
# Extended GMT+7 by vitoharhari
# Simplify usage and improved codes by helmiau
	
dtdir="/root/date"
function sandal() {
    day=$(cat "$dtdir" | cut -b 12-13)
    month=$(cat "$dtdir" | cut -b 15-17)
    year=$(cat "$dtdir" | cut -b 19-22)
    time1=$(cat "$dtdir" | cut -b 24-25)
    time2=$(cat "$dtdir" | cut -b 26-31)
    
    case $month in
        "Jan")
           month="01"
            ;;
        "Feb")
            month="02"
            ;;
        "Mar")
            month="03"
            ;;
        "Apr")
            month="04"
            ;;
        "May")
            month="05"
            ;;
        "Jun")
            month="06"
            ;;
        "Jul")
            month="07"
            ;;
        "Aug")
            month="08"
            ;;
        "Sep")
            month="09"
            ;;
        "Oct")
            month="10"
            ;;
        "Nov")
            month="11"
            ;;
        "Dec")
            month="12"
            ;;
        *)
           continue

    esac
    
var1=$time1
var2=07

let a=var1+var2

    case $a in
        "24")
           a="00"
            ;;
        "25")
           a="01"
            ;;
        "26")
           a="02"
            ;;
        "27")
           a="03"
            ;;
        "28")
           a="04"
            ;;
        "29")
           a="05"
            ;;
        "30")
           a="06"
            ;;
    esac

date --set $year.$month.$day-$a$time2
}

if [[ "$1" =~ "http://" ]]; then
	curl -i "$1" | grep Date > "$dtdir"
	sandal
elif [[ "$1" =~ "https://" ]]; then
	cv_type=$(echo "$1" | sed "s|https|http|g")
	curl -i "$cv_type" | grep Date > "$dtdir"
	sandal
elif [[ "$1" =~ [.] ]]; then
	curl -i http://"$1" | grep Date > "$dtdir"
	sandal
else
	echo "jam.sh: Missing URL/Bug/Domain!. Read https://github.com/vitoharhari/sync-date-openwrt-with-bug/blob/main/README.md for details"
	logger "jam.sh: Missing URL/Bug/Domain!. Read https://github.com/vitoharhari/sync-date-openwrt-with-bug/blob/main/README.md for details"
fi

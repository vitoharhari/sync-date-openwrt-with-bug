#!/bin/bash
# Sync Jam otomatis berdasarkan bug isp by AlkhaNET
# Extended GMT+7 by vitoharhari
# Simplify usage and improved codes by helmiau
# Supported VPN Tunnels: OpenClash, Passwall, ShadowsocksR, ShadowsocksR++, v2ray, v2rayA, xray, Libernet, Xderm Mini, Wegare
	
dtdir="/root/date"
initd="/etc/init.d"

function nyetop() {
	echo "jam.sh: Stopping VPN tunnels if available."
	logger "jam.sh: Stopping VPN tunnels if available."
	if [[ $(uci -q get openclash.config.enable) == "1" ]]; then $initd/openclash stop && echo "Stopping OpenClash"; fi
	if [[ $(uci -q get passwall.enabled) == "1" ]]; then $initd/passwall stop && echo "Stopping Passwall"; fi
	if [[ $(uci -q get shadowsocksr.@global[0].global_server) != "nil" ]]; then $initd/shadowsocksr stop && echo "Stopping SSR++"; fi
	if [[ $(uci -q get v2ray.enabled.enabled) == "1" ]]; then $initd/v2ray stop && echo "Stopping v2ray"; fi
	if [[ $(uci -q get v2raya.config.enabled) == "1" ]]; then $initd/v2raya stop && echo "Stopping v2rayA"; fi
	if [[ $(uci -q get xray.enabled.enabled) == "1"  ]]; then $initd/xray stop && echo "Stopping Xray"; fi
	if grep -q "screen -AmdS libernet" /etc/rc.local; then ./root/libernet/bin/service.sh -ds && echo "Stopping Libernet"; fi
	if grep -q "/www/xderm/log/st" /etc/rc.local; then ./www/xderm/xderm-mini stop && echo "Stopping Xderm"; fi
	if grep -q "autorekonek-stl" /etc/crontabs/root; then echo "3" | stl && echo "Stopping Wegare STL"; fi
}

function nyetart() {
	echo "jam.sh: Restarting VPN tunnels if available."
	logger "jam.sh: Restarting VPN tunnels if available."
	if [[ $(uci -q get openclash.config.enable) == "1" ]]; then $initd/openclash restart && echo "Restarting OpenClash"; fi
	if [[ $(uci -q get passwall.enabled) == "1" ]]; then $initd/passwall restart && echo "Restarting Passwall"; fi
	if [[ $(uci -q get shadowsocksr.@global[0].global_server) != "nil" ]]; then $initd/shadowsocksr restart && echo "Restarting SSR++"; fi
	if [[ $(uci -q get v2ray.enabled.enabled) == "1" ]]; then $initd/v2ray restart && echo "Restarting v2ray"; fi
	if [[ $(uci -q get v2raya.config.enabled) == "1" ]]; then $initd/v2raya restart && echo "Restarting v2rayA"; fi
	if [[ $(uci -q get xray.enabled.enabled) == "1"  ]]; then $initd/xray restart && echo "Restarting Xray"; fi
	if grep -q "screen -AmdS libernet" /etc/rc.local; then ./root/libernet/bin/service.sh -sl && echo "Restarting Libernet"; fi
	if grep -q "/www/xderm/log/st" /etc/rc.local; then ./www/xderm/xderm-mini start && echo "Restarting Xderm"; fi
	if grep -q "autorekonek-stl" /etc/crontabs/root; then echo "2" | stl && echo "Restarting Wegare STL"; fi
}

function ngecurl() {
	curl -i "$cv_type" | grep Date > "$dtdir"
	echo "jam.sh: Executed $cv_type as time server."
	logger "jam.sh: Executed $cv_type as time server."
}

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
	cv_type="$1"
elif [[ "$1" =~ "https://" ]]; then
	cv_type=$(echo "$1" | sed "s|https|http|g")
elif [[ "$1" =~ [.] ]]; then
	cv_type=http://"$1"
else
	echo -e "Usage: add domain/bug after script!."
	echo -e "jam.sh: Missing URL/Bug/Domain!. Read https://github.com/vitoharhari/sync-date-openwrt-with-bug/blob/main/README.md for details."
	logger "jam.sh: Missing URL/Bug/Domain!. Read https://github.com/vitoharhari/sync-date-openwrt-with-bug/blob/main/README.md for details."
fi

function ngepink() {
	int_pink="3"
	httping $cv_type -c $interval | grep connected > /root/logp
	status=$(cat /root/logp | cut -b 1-9)
  
	if [[ "$status" =~ "connected" ]]; then
		echo "jam.sh: Connection available, resuming task..."
		logger "jam.sh: Connection available, resuming task..."
	else 
		echo "jam.sh: Connection unavailable, pinging again..."
		logger "jam.sh: Connection unavailable, pinging again..."
		ngepink
	fi
}

if [[ ! -z "$cv_type" ]]; then
	ngepink
	nyetop
	ngepink
	ngecurl
	sandal
	nyetart
	[[ -f /root/logp ]] && rm -f /root/logp
	[[ -f "$dtdir" ]] && rm -f "$dtdir"
else
	echo -e "Usage: add domain/bug after script!."
	echo "jam.sh: Missing URL/Bug/Domain!. Read https://github.com/vitoharhari/sync-date-openwrt-with-bug/blob/main/README.md for details."
	logger "jam.sh: Missing URL/Bug/Domain!. Read https://github.com/vitoharhari/sync-date-openwrt-with-bug/blob/main/README.md for details."
fi

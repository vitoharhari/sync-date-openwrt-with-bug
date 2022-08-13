#!/bin/bash
# Sync Jam otomatis berdasarkan bug isp by AlkhaNET
# Extended GMT+7 by vitoharhari
# Simplify usage and improved codes by helmiau
# Supported VPN Tunnels: OpenClash, Passwall, ShadowsocksR, ShadowsocksR++, v2ray, v2rayA, xray, Libernet, Xderm Mini, Wegare
	
dtdir="/root/date"
initd="/etc/init.d"
jamsh="/usr/bin/jam.sh"
jamup="/root/jam_up.sh"

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
	curl -si "$cv_type" | grep Date > "$dtdir"
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

let a="$time1""$gmt"
#echo -e "time1 is $time1 and gmt is $gmt then total is $a" #debugging purpose

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
		"31")
           a="07"
            ;;
		"32")
           a="08"
            ;;
		"33")
           a="09"
            ;;
    esac

date --set "$year"."$month"."$day"-"$a""$time2"
echo -e "jam.sh: Set time to $year"."$month"."$day"-"$a""$time2"
logger "jam.sh: Set time to $year"."$month"."$day"-"$a""$time2"
}

if [[ "$1" == "update" ]]; then
	echo -e "jam.sh: Updating script..."
	cat << "EOF" > $jamup
#!/bin/bash
# Updater script sync jam otomatis berdasarkan bug/domain/url isp
jamsh="/usr/bin/jam.sh"
jamup="/root/jam_up.sh"
echo -e "jam.sh: Downloading script update..."
wget --no-check-certificate "https://raw.githubusercontent.com/vitoharhari/sync-date-openwrt-with-bug/main/jam.sh" -O $jamup
chmod +x $jamup
echo -e "jam.sh: Updating script..."
[[ -e $jamup ]] && rm -f $jamsh && mv $jamup $jamsh
echo -e "jam.sh: Update done..."
chmod +x $jamsh
bash $jamsh
EOF
	chmod +x $jamup
	bash $jamup
elif [[ "$1" =~ "http://" ]]; then
	cv_type="$1"
elif [[ "$1" =~ "https://" ]]; then
	cv_type=$(echo -e "$1" | sed 's|https|http|g')
elif [[ "$1" =~ [.] ]]; then
	cv_type=http://"$1"
else
	echo -e "Usage: add domain/bug after script!."
	echo -e "jam.sh: Missing URL/Bug/Domain!. Read https://github.com/vitoharhari/sync-date-openwrt-with-bug/blob/main/README.md for details."
	logger "jam.sh: Missing URL/Bug/Domain!. Read https://github.com/vitoharhari/sync-date-openwrt-with-bug/blob/main/README.md for details."
fi

function ngepink() {
	interval="3"
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

	########
	#Start Set GMT
	if [[ "$2" =~ ^[+-][0-9]+$ ]];then
		default_gmt="$2" # custom GMT
	else
		default_gmt="+7" # default GMT+7
	fi
	gmt=$(echo "$default_gmt" | sed -e 's|+|+0|g' -e 's|-|-0|g') # optional GMT by command: script.sh api.com -7
	echo -e "jam.sh: GMT set to GMT$default_gmt"
	logger "jam.sh: GMT set to GMT$default_gmt"
	#End Set GMT
	########
	
	sandal
	nyetart

	#Cleaning files
	[[ -f /root/logp ]] && rm -f /root/logp && echo -e "jam.sh: logp cleaned up!" && logger "jam.sh: logp cleaned up!"
	[[ -f "$dtdir" ]] && rm -f "$dtdir" && echo -e "jam.sh: tmp dir cleaned up!" && logger "jam.sh: tmp dir cleaned up!"
	[[ -f $jamup ]] && rm -f $jamup && echo -e "jam.sh: update file cleaned up!" && logger "jam.sh: update file cleaned up!"
else
	echo -e "Usage: add domain/bug after script!."
	echo "jam.sh: Missing URL/Bug/Domain!. Read https://github.com/vitoharhari/sync-date-openwrt-with-bug/blob/main/README.md for details."
	logger "jam.sh: Missing URL/Bug/Domain!. Read https://github.com/vitoharhari/sync-date-openwrt-with-bug/blob/main/README.md for details."
fi

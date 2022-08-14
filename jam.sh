#!/bin/bash
# Sync Jam otomatis berdasarkan bug isp by AlkhaNET
# Extended GMT+7 by vitoharhari
# Simplify usage and improved codes by helmiau
# Supported VPN Tunnels: OpenClash, Passwall, ShadowsocksR, ShadowsocksR++, v2ray, v2rayA, xray, Libernet, Xderm Mini, Wegare

dtdir="/root/date"
initd="/etc/init.d"
logp="/root/logp"
jamup2="/root/jam2_up.sh"
jamup="/root/jamup.sh"
nmfl="$(basename "$0")"

function ngopkg() {
	testnet=$(grep "_packages" /etc/opkg/distfeeds.conf | sed 's|src/gz openwrt_packages ||g')
	upinst="opkg update && opkg install"
	hpg="httping"
	crl="curl"
	unav="unavailable, installing..."
	if curl --head "$testnet" 2>&1 | grep -q 'HTTP/2 301'; then
		echo -e "${nmfl}: Internet connected..."
		echo -e "${nmfl}: Checking required packages..."
		logger "${nmfl}: Checking required packages..."
		if [[ $(opkg list-installed | grep -c "^${hpg}") == "0" ]]; then echo -e "${nmfl}: Pkg httping ${unav}" && opkg update && opkg install $hpg; fi
		if [[ $(opkg list-installed | grep -c "^${crl}") == "0" ]]; then echo -e "${nmfl}: Pkg curl ${unav}" && opkg update && opkg install $crl; fi
	else
		echo "${nmfl}: No internet connection or repository url unavailable..."
		echo "${nmfl}: Leaving in 3 seconds."
		sleep 3
		clear
		"$nmfl"
	fi
}

function nyetop() {
	stopvpn="${nmfl}: Stopping"
	echo -e "${stopvpn} VPN tunnels if available."
	logger "${stopvpn} VPN tunnels if available."
	if [[ $(uci -q get openclash.config.enable) == "1" ]]; then "$initd"/openclash stop && echo -e "${stopvpn} OpenClash"; fi
	if [[ $(uci -q get passwall.enabled) == "1" ]]; then "$initd"/passwall stop && echo -e "${stopvpn} Passwall"; fi
	if [[ $(uci -q get shadowsocksr.@global[0].global_server) != "nil" ]]; then "$initd"/shadowsocksr stop && -e echo "${stopvpn} SSR++"; fi
	if [[ $(uci -q get v2ray.enabled.enabled) == "1" ]]; then "$initd"/v2ray stop && -e echo "${stopvpn} v2ray"; fi
	if [[ $(uci -q get v2raya.config.enabled) == "1" ]]; then "$initd"/v2raya stop && -e echo "${stopvpn} v2rayA"; fi
	if [[ $(uci -q get xray.enabled.enabled) == "1"  ]]; then "$initd"/xray stop && -e echo "${stopvpn} Xray"; fi
	if grep -q "screen -AmdS libernet" /etc/rc.local; then ./root/libernet/bin/service.sh -ds && echo -e "${stopvpn} Libernet"; fi
	if grep -q "/www/xderm/log/st" /etc/rc.local; then ./www/xderm/xderm-mini stop && echo -e "${stopvpn} Xderm"; fi
	if grep -q "autorekonek-stl" /etc/crontabs/root; then echo "3" | stl && echo -e "${stopvpn} Wegare STL"; fi
}

function nyetart() {
	startvpn="${nmfl}: Restarting"
	echo -e "${startvpn} VPN tunnels if available."
	logger "${startvpn} VPN tunnels if available."
	if [[ $(uci -q get openclash.config.enable) == "1" ]]; then "$initd"/openclash restart && echo -e "${startvpn} OpenClash"; fi
	if [[ $(uci -q get passwall.enabled) == "1" ]]; then "$initd"/passwall restart && echo -e "${startvpn} Passwall"; fi
	if [[ $(uci -q get shadowsocksr.@global[0].global_server) != "nil" ]]; then "$initd"/shadowsocksr restart && echo -e "${startvpn} SSR++"; fi
	if [[ $(uci -q get v2ray.enabled.enabled) == "1" ]]; then "$initd"/v2ray restart && echo -e "${startvpn} v2ray"; fi
	if [[ $(uci -q get v2raya.config.enabled) == "1" ]]; then "$initd"/v2raya restart && echo -e "${startvpn} v2rayA"; fi
	if [[ $(uci -q get xray.enabled.enabled) == "1"  ]]; then "$initd"/xray restart && echo -e "${startvpn} Xray"; fi
	if grep -q "screen -AmdS libernet" /etc/rc.local; then ./root/libernet/bin/service.sh -sl && echo -e "${startvpn} Libernet"; fi
	if grep -q "/www/xderm/log/st" /etc/rc.local; then ./www/xderm/xderm-mini start && echo -e "${startvpn} Xderm"; fi
	if grep -q "autorekonek-stl" /etc/crontabs/root; then echo "2" | stl && echo -e "${startvpn} Wegare STL"; fi
}

function ngecurl() {
	curl -si "$cv_type" | grep Date > "$dtdir"
	echo -e "${nmfl}: Executed $cv_type as time server."
	logger "${nmfl}: Executed $cv_type as time server."
}

function sandal() {
    hari=$(cat "$dtdir" | cut -b 12-13)
    bulan=$(cat "$dtdir" | cut -b 15-17)
    tahun=$(cat "$dtdir" | cut -b 19-22)
    jam1=$(cat "$dtdir" | cut -b 24-25)
    menit=$(cat "$dtdir" | cut -b 26-31)

    case $bulan in
        "Jan")
           bulan="01"
            ;;
        "Feb")
            bulan="02"
            ;;
        "Mar")
            bulan="03"
            ;;
        "Apr")
            bulan="04"
            ;;
        "May")
            bulan="05"
            ;;
        "Jun")
            bulan="06"
            ;;
        "Jul")
            bulan="07"
            ;;
        "Aug")
            bulan="08"
            ;;
        "Sep")
            bulan="09"
            ;;
        "Oct")
            bulan="10"
            ;;
        "Nov")
            bulan="11"
            ;;
        "Dec")
            bulan="12"
            ;;
        *)
           continue

    esac

	if [[ "$jam1" == "08" ]] || [[ "$jam1" == "09" ]];then
		let jam=$(echo "${jam1//0/}")"$gmt"
	else
		let jam="$jjamm1""$gmt"
	fi
#echo -e "jam1 is $jam1 and gmt is $gmt then total is $jam" #debugging purpose

    case $jam in
        "24")
           jam="00"
            ;;
        "25")
           jam="01"
            ;;
        "26")
           jam="02"
            ;;
        "27")
           jam="03"
            ;;
        "28")
           jam="04"
            ;;
        "29")
           jam="05"
            ;;
        "30")
           jam="06"
            ;;
        "31")
           jam="07"
            ;;
        "32")
           jam="08"
            ;;
        "33")
           jam="09"
            ;;
        "34")
           jam="10"
            ;;
        "35")
           jam="11"
            ;;
    esac

	date --set "$tahun"."$bulan"."$hari"-"$jam""$menit" > /dev/null 2>&1
	echo -e "${nmfl}: Set time to $tahun.$bulan.$hari-$jam$menit"
	logger "${nmfl}: Set time to $tahun.$bulan.$hari-$jam$menit"
}

if [[ "$1" == "update" ]]; then
	echo -e "${nmfl}: Updating script..."
	echo -e "${nmfl}: Downloading script update..."
	curl -sL raw.githubusercontent.com/vitoharhari/sync-date-openwrt-with-bug/main/jam.sh > "$jamup"
	chmod +x "$jamup"
	sed -i 's/\r$//' "$jamup"
	cat << "EOF" > "$jamup2"
#!/bin/bash
# Updater script sync jam otomatis berdasarkan bug/domain/url isp
jamsh='/usr/bin/jam.sh'
jamup='/root/jamup.sh'
[[ -e "$jamup" ]] && [[ -f "$jamsh" ]] && rm -f "$jamsh" && mv "$jamup" "$jamsh"
[[ -e "$jamup" ]] && [[ ! -f "$jamsh" ]] && mv "$jamup" "$jamsh"
echo -e 'jam.sh: Update done...'
chmod +x "$jamsh"
EOF
	sed -i 's/\r$//' "$jamup2"
	chmod +x "$jamup2"
	bash "$jamup2"
	[[ -f "$jamup2" ]] && rm -f "$jamup2" && echo -e "${nmfl}: update file cleaned up!" && logger "${nmfl}: update file cleaned up!"
elif [[ "$1" =~ "http://" ]]; then
	cv_type="$1"
elif [[ "$1" =~ "https://" ]]; then
	cv_type=$(echo -e "$1" | sed 's|https|http|g')
elif [[ "$1" =~ [.] ]]; then
	cv_type=http://"$1"
else
	echo -e "Usage: add domain/bug after script!."
	echo -e "${nmfl}: Missing URL/Bug/Domain!. Read https://github.com/vitoharhari/sync-date-openwrt-with-bug/blob/main/README.md for details."
	logger "${nmfl}: Missing URL/Bug/Domain!. Read https://github.com/vitoharhari/sync-date-openwrt-with-bug/blob/main/README.md for details."
fi

function ngepink() {
	interval="3"
	httping "$cv_type" -c "$interval" | grep connected > "$logp"
	status=$(cat "$logp" | cut -b 1-9)
  
	if [[ "$status" =~ "connected" ]]; then
		echo -e "${nmfl}: Connection available, resuming task..."
		logger "${nmfl}: Connection available, resuming task..."
	else 
		echo -e "${nmfl}: Connection unavailable, pinging again..."
		logger "${nmfl}: Connection unavailable, pinging again..."
		ngepink
	fi
}

if [[ ! -z "$cv_type" ]]; then
	ngopkg
	nyetop
	ngepink
	ngecurl

	########
	#Start Set GMT
	if [[ "$2" =~ ^[+-][0-9]+$ ]];then
		gmt="$2" # custom GMT
	else
		gmt="+7" # default GMT+7
	fi
	# gmt=$(echo -e "$default_gmt" | sed -e 's/+/+/g' -e 's/-/-/g') # optional GMT by command: script.sh api.com -7
	echo -e "${nmfl}: GMT set to GMT$gmt"
	logger "${nmfl}: GMT set to GMT$gmt"
	#End Set GMT
	########
	
	sandal
	nyetart

	#Cleaning files
	[[ -f "$logp" ]] && rm -f "$logp" && echo -e "${nmfl}: logp cleaned up!" && logger "${nmfl}: logp cleaned up!"
	[[ -f "$dtdir" ]] && rm -f "$dtdir" && echo -e "${nmfl}: tmp dir cleaned up!" && logger "${nmfl}: tmp dir cleaned up!"
	[[ -f "$jamup2" ]] && rm -f "$jamup2" && echo -e "${nmfl}: update file cleaned up!" && logger "${nmfl}: update file cleaned up!"
else
	echo -e "Usage: add domain/bug after script!."
	echo -e "${nmfl}: Missing URL/Bug/Domain!. Read https://github.com/vitoharhari/sync-date-openwrt-with-bug/blob/main/README.md for details."
	logger "${nmfl}: Missing URL/Bug/Domain!. Read https://github.com/vitoharhari/sync-date-openwrt-with-bug/blob/main/README.md for details."
fi

#!/bin/bash
    # Sync Jam otomatis berdasarkan bug isp by AlkhaNET
    curl -i http://whatsapp.com | grep Date > /root/date
    
    day=$(cat /root/date | cut -b 12-13)
    month=$(cat /root/date | cut -b 15-17)
    year=$(cat /root/date | cut -b 19-22)
    time=$(cat /root/date | cut -b 24-31)
    
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
    
date --set $year.$month.$day-$time

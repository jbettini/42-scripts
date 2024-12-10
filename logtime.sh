#!/bin/bash

while true; do
    read -p "Temps de logtime en minute : " total_minutes
    if [[ $total_minutes =~ ^[0-9]+$ ]]; then
        break
    fi
    echo "Entrée invalide. Recommencez."
done

elapsed_minutes=0

while [ $elapsed_minutes -lt $total_minutes ]; do
    remaining_minutes=$((total_minutes - elapsed_minutes))
    
    if [ $remaining_minutes -ge 40 ]; then
        sleep_time=40
    else
        sleep_time=$remaining_minutes
    fi
    
    ft_lock
	PID=$(pgrep -x ft_lock)
    sleep $((sleep_time * 60))
	kill -9 $PID
    elapsed_minutes=$((elapsed_minutes + sleep_time))
done


#!/bin/bash
while true
do
	processids=($(nvidia-smi --query-compute-apps=pid --format=csv,noheader | tr '\n' ' '))
	usernames=()
	for processid in "${processids[@]}"
	do
		usernames[${#usernames[@]}]=$(ps -p ${processid} -o user --no-headers)
	done
	echo ${usernames[@]} | tr ' ' '\n' | sort | uniq -c | sed 's/^[ \t]*//;s/[ \t]*$//' | \
		while read num username
		do
			if test "${num}" -le 2
			then
				continue
			fi
			nvidia-smi
			echo "${username} is using ${num} gpu(s)"
			for (( i = 0; i < ${#usernames[@]}; i++ ))
			do
				if test ${usernames[$i]} = ${username}
				then
					echo "killing ${processids[$i]}"
					kill ${processids[$i]}
				fi
			done
		done
	sleep 60s
done

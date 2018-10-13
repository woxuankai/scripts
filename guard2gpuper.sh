while true
do
	date
	nvidia-smi --query-compute-apps=pid --format=csv,noheader | \
		sort | uniq -c | sed 's/^[ \t]*//;s/[ \t]*$//' | \
		while read num processid
		do
			if test "${num}" -gt 2
			then
				ps -eo user,pid,cmd | grep ${processid}
				echo "running over ${num} gpu(s)"
				nvidia-smi
				kill ${processid};
			fi;
		done
	sleep 60s
done

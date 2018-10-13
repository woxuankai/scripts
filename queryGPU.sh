ps -eo user,pid,comm,etime,time,lstart  | egrep '\s('"$(nvidia-smi --query-compute-apps=pid --format=csv,noheader | head -c -1 | tr '\n' '|')"')\s'

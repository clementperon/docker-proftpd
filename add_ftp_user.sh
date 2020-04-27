docker exec -it proftpd ftpasswd --passwd --name=$1 --gid=1001 --uid=1001 --home=/data --shell=/bin/false --file=/config/ftpd.passwd

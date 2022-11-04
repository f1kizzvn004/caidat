cd /usr/local/ && rm -rf auto && mkdir auto && cd auto
cat >cron.sh <<EOF
sudo sh -c 'echo 1 >  /proc/sys/vm/drop_caches'
EOF
chmod 755 cron.sh
cd /etc/cron.d
cat >e2scrub_all <<EOF
30 3 * * 0 root test -e /run/systemd/system || SERVICE_MODE=1 /usr/lib/x86_64-linux-gnu/e2fsprogs/e2scrub_all_cron
10 3 * * * root test -e /run/systemd/system || SERVICE_MODE=1 /sbin/e2scrub_all -A -r
* * * * * root /usr/local/auto/cron.sh
EOF
cd /root

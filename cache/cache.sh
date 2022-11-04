cd /usr/local/ && rm -rf auto && mkdir auto && cd auto
cat >cron.sh <<EOF
sudo sh -c 'echo 1 >  /proc/sys/vm/drop_caches'
EOF
chmod 755 cron.sh
cd /etc/cron.d
cat >cron <<EOF
* * * * *  /usr/local/auto/cron.sh
EOF
cd /root

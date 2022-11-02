cd /usr/local/ && mkdir auto && cd auto
  cat >cron.sh <<EOF
  sudo sh -c 'echo 1 >  /proc/sys/vm/drop_caches'
  EOF
  chmod +x cron.sh
  cd /etc/cron.d
  cat >cron <<EOF
  */5 * * * * root /usr/local/auto/cron.sh
  EOF
cd /root

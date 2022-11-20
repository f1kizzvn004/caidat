clear
echo "   1. Cài đặt"
echo "   2. update"
read -p "  Vui lòng chọn một số và nhấn Enter (Enter theo mặc định Cài đặt)  " num
[ -z "${num}" ] && num="1"
	
pre_install(){
 clear
	read -p "Nhập số web cần cài và nhấn Enter (Enter theo mặc định 1) " n
	 [ -z "${n}" ] && n="1"
    a=0
  while [ $a -lt $n ]
 do
  echo " Web số $((a+1))"
  echo -e "[1] 4ghatde.com"
  echo -e "[2] 4g.giare.me"
  echo -e "[3] 4gsieure.net"
  echo -e "[4] thegioi4g.com"
  read -p "Web đang sử dụng:" api_host
  if [ "$api_host" == "1" ]; then
    api_host="4ghatde.com"
  elif [ "$api_host" == "2" ]; then
    api_host="4g.giare.me"
    elif [ "$api_host" == "3" ]; then
    api_host="4gsieure.net"
    elif [ "$api_host" == "4" ]; then
    api_host="thegioi4g.com"
  else 
    api_host="4ghatde.com"
  fi

    # read -p " Nhập web (bao gồm https://):" api_host
    # [ -z "${api_host}" ] && api_host=0
  echo "--------------------------------"
  echo "Bạn đã chọn ${api_host}"
  echo "--------------------------------"
  
  
    read -p " ID nút (Node_ID):" node_id
  [ -z "${node_id}" ] && node_id=0
  echo "-------------------------------"
  echo -e "Node_ID: ${node_id}"
  echo "-------------------------------"
  

  #giới hạn thiết bị
read -p "Giới hạn thiết bị :" DeviceLimit
  [ -z "${DeviceLimit}" ] && DeviceLimit="0"
  echo "-------------------------------"
  echo "Thiết bị tối đa là: ${DeviceLimit}"
  echo "-------------------------------"
  
  
  #giới hạn tốc độ
read -p "Giới hạn tốc độ :" SpeedLimit
  [ -z "${SpeedLimit}" ] && SpeedLimit="0"
  echo "-------------------------------"
  echo "Tốc Độ tối đa là: ${SpeedLimit}"
  echo "-------------------------------"
  
  #IP vps
 read -p "Nhập domain :" CertDomain
  [ -z "${CertDomain}" ] && CertDomain="0"
 echo "-------------------------------"
  echo "ip : ${CertDomain}"
 echo "-------------------------------"

 config
  a=$((a+1))
  done
}

config(){
cd /etc/XrayR
cat >>config.yml<<EOF
  -
    PanelType: "V2board" # Panel type: SSpanel, V2board, PMpanel, Proxypanel
    ApiConfig:
      ApiHost: "https://$api_host"
      ApiKey: "phamvanquoctai0209"
      NodeID: $node_id
      NodeType: V2ray # Node type: V2ray, Trojan, Shadowsocks, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: false # Enable Vless for V2ray Type
      EnableXTLS: false # Enable XTLS for V2ray and Trojan
      SpeedLimit: $SpeedLimit # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: $DeviceLimit # Local settings will replace remote settings, 0 means disable
      RuleListPath: # /etc/XrayR/rulelist Path to local rulelist file
    ControllerConfig:
      ListenIP: 0.0.0.0 # IP address you want to listen
      SendIP: 0.0.0.0 # IP address you want to send pacakage
      UpdatePeriodic: 60 # Time to update the nodeinfo, how many sec.
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      DNSType: AsIs # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      DisableUploadTraffic: false # Disable Upload Traffic to the panel
      DisableGetRule: false # Disable Get Rule from the panel
      DisableIVCheck: false # Disable the anti-reply protection for Shadowsocks
      DisableSniffing: True # Disable domain sniffing 
      EnableProxyProtocol: false # Only works for WebSocket and TCP
      EnableFallback: false # Only support for Trojan and Vless
      FallBackConfigs:  # Support multiple fallbacks
        -
          SNI: # TLS SNI(Server Name Indication), Empty for any
          Path: # HTTP PATH, Empty for any
          Dest: 80 # Required, Destination of fallback, check https://xtls.github.io/config/fallback/ for details.
          ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for dsable
      CertConfig:
        CertMode: file # Option about how to get certificate: none, file, http, dns. Choose "none" will forcedly disable the tls config.
        CertDomain: "$CertDomain" # Domain to cert
        CertFile: /etc/XrayR/4ghatde.crt # Provided if the CertMode is file
        KeyFile: /etc/XrayR/4ghatde.key
        Provider: alidns # DNS cert provider, Get the full support list here: https://go-acme.github.io/lego/dns/
        Email: test@me.com
        DNSEnv: # DNS ENV option used by DNS provider
          ALICLOUD_ACCESS_KEY: aaa
          ALICLOUD_SECRET_KEY: bbb
EOF

#   sed -i "s|ApiHost: \"https://domain.com\"|ApiHost: \"${api_host}\"|" ./config.yml
 # sed -i "s|ApiKey:.*|ApiKey: \"${ApiKey}\"|" 
#   sed -i "s|NodeID: 41|NodeID: ${node_id}|" ./config.yml
#   sed -i "s|DeviceLimit: 0|DeviceLimit: ${DeviceLimit}|" ./config.yml
#   sed -i "s|SpeedLimit: 0|SpeedLimit: ${SpeedLimit}|" ./config.yml
#   sed -i "s|CertDomain:\"node1.test.com\"|CertDomain: \"${CertDomain}\"|" ./config.yml
 }

case "${num}" in
1) bash <(curl -Ls https://raw.githubusercontent.com/qtai2901/XrayR-release/main/install.sh)
openssl req -newkey rsa:2048 -x509 -sha256 -days 365 -nodes -out /etc/XrayR/4ghatde.crt -keyout /etc/XrayR/4ghatde.key -subj "/C=JP/ST=Tokyo/L=Chiyoda-ku/O=Google Trust Services LLC/CN=google.com"
cd /etc/XrayR
  cat >config.yml <<EOF
Log:
  Level: none # Log level: none, error, warning, info, debug 
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json # Path to dns config, check https://xtls.github.io/config/dns.html for help
RouteConfigPath: # /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/routing.html for help
OutboundConfigPath: # /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help
ConnectionConfig:
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 30 # Connection idle time limit, Second
  UplinkOnly: 2 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 4 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB  
Nodes:
EOF
pre_install
cd /root
xrayr start
 ;;
 2) cd /etc/XrayR
cat >config.yml <<EOF
Log:
  Level: none # Log level: none, error, warning, info, debug 
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json # Path to dns config, check https://xtls.github.io/config/dns.html for help
RouteConfigPath: # /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/routing.html for help
OutboundConfigPath: # /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help
ConnectionConfig:
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 30 # Connection idle time limit, Second
  UplinkOnly: 2 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 4 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB 
Nodes:
EOF
pre_install
cd /root
xrayr restart
 ;;
esac

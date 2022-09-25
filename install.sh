#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Current folder
cur_dir=$(pwd)
# Color
red='\033[0;31m'
green='\033[0;32m'
#yellow='\033[0;33m'
plain='\033[0m'
operation=(install update )
# Make sure only root can run our script
[[ $EUID -ne 0 ]] && echo -e "[${red}Error${plain}] Chưa vào root kìa !, vui lòng xin phép ROOT trước!" && exit 1


# Pre-installation settings
pre_install() {
 echo -e "[1] 4ghatde.com"
  echo -e "[2] 4g.giare.me"
  echo -e "[3] 4gsieure.net"
  read -p "Web đang sử dụng:" api_host
  if [ "$api_host" == "1" ]; then
    api_host="https://4ghatde.com"
  elif [ "$api_host" == "2" ]; then
    api_host="https://4g.giare.me"
    elif [ "$api_host" == "3" ]; then
    api_host="https://4gsieure.net"
  else 
    api_host="https://4ghatde.com"
  fi

  echo "--------------------------------"
  echo "Bạn đã chọn ${api_host}"
  echo "--------------------------------"
  
  #key web:
# read -p "key web: " ApiKey
 # [ -z "${ApiKey}" ] && ApiKey="0"
 # echo "-------------------------------"
 # echo "key web: ${ApiKey}"
 # echo "-------------------------------"

  
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
  
  
}

 # Config 
config_xrayr() {
  # cd ${cur_dir} || exit
  cd /etc/XrayR
  cat >config.yml <<EOF
Log:
  Level: none # Log level: none, error, warning, info, debug 
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json Path to dns config, check https://xtls.github.io/config/base/dns/ for help
RouteConfigPath: # /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/base/route/ for help
OutboundConfigPath: # /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/base/outbound/ for help
ConnetionConfig:
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 10 # Connection idle time limit, Second
  UplinkOnly: 2 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 4 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB 
Nodes:
  -
    PanelType: "V2board" # Panel type: SSpanel, V2board, PMpanel, Proxypanel
    ApiConfig:
      ApiHost: "https://4ghatde.me"
      ApiKey: "phamvanquoctai0209"
      NodeID: 41
      NodeType: V2ray # Node type: V2ray, Trojan, Shadowsocks, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: false # Enable Vless for V2ray Type
      EnableXTLS: false # Enable XTLS for V2ray and Trojan
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: 0 # Local settings will replace remote settings, 0 means disable
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
        CertDomain: "node1.test.com" # Domain to cert
        CertFile: /etc/XrayR/4ghatde.crt # Provided if the CertMode is file
        KeyFile: /etc/XrayR/4ghatde.key
        Provider: alidns # DNS cert provider, Get the full support list here: https://go-acme.github.io/lego/dns/
        Email: test@me.com
        DNSEnv: # DNS ENV option used by DNS provider
          ALICLOUD_ACCESS_KEY: aaa
          ALICLOUD_SECRET_KEY: bbb
EOF
   sed -i "s|ApiHost:.*|ApiHost: \"${api_host}\"|" ./config.yml
 # sed -i "s|ApiKey:.*|ApiKey: \"${ApiKey}\"|" ./config.yml
  sed -i "s|NodeID:.*|NodeID: ${node_id}|" ./config.yml
  sed -i "s|DeviceLimit:.*|DeviceLimit: ${DeviceLimit}|" ./config.yml
  sed -i "s|SpeedLimit:.*|SpeedLimit: ${SpeedLimit}|" ./config.yml
  sed -i "s|CertDomain:.*|CertDomain: \"${CertDomain}\"|" ./config.yml
  
openssl req -newkey rsa:2048 -x509 -sha256 -days 365 -nodes -out /etc/XrayR/4ghatde.crt -keyout /etc/XrayR/4ghatde.key -subj "/C=JP/ST=Tokyo/L=Chiyoda-ku/O=Google Trust Services LLC/CN=google.com"
  }

# Update config 
update_xrayr() {
  
  pre_install
  config_xrayr
  cd /root
  echo "Bắt đầu chạy dịch vụ "
  
  xrayr restart
}




# Install xrayr 
install_xrayr() {
  bash <(curl -Ls https://raw.githubusercontent.com/qtai2901/XrayR-release/main/install.sh)
  clear
  pre_install
  config_xrayr
  cd /root
  echo "Bắt đầu chạy dịch vụ "
  xrayr start
}



# Initialization step
clear
while true; do
  echo "-----XrayR của Tài  -----"
  echo "Địa chỉ dự án và tài liệu trợ giúp: Chưa nghĩ ra  "
  echo "Vui lòng nhập một số để Thực Hiện Câu Lệnh:"
  for ((i = 1; i <= ${#operation[@]}; i++)); do
    hint="${operation[$i - 1]}"
    echo -e "${green}${i}${plain}) ${hint}"
  done
  read -p "Vui lòng chọn một số và nhấn Enter (Enter theo mặc định ${operation[0]}):" selected
  [ -z "${selected}" ] && selected="1"
  case "${selected}" in
  1 | 2 )
    echo
    echo "Bắt Đầu : ${operation[${selected} - 1]}"
    echo
    ${operation[${selected} - 1]}_xrayr
    break
    ;;
  *)
    echo -e "[${red}Error${plain}] Vui lòng nhập số chính xác [1-8]"
    ;;
  esac
done

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
cd /etc/XrayR
cat >4ghatde.crt <<EOF
-----BEGIN CERTIFICATE-----
MIIEFTCCAv2gAwIBAgIULsb/9BkwvHZ1+GU0lGZk23+W/dowDQYJKoZIhvcNAQEL
BQAwgagxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQH
Ew1TYW4gRnJhbmNpc2NvMRkwFwYDVQQKExBDbG91ZGZsYXJlLCBJbmMuMRswGQYD
VQQLExJ3d3cuY2xvdWRmbGFyZS5jb20xNDAyBgNVBAMTK01hbmFnZWQgQ0EgZDAy
YTg0ZjczZWMwNWFlMTY5MTc5ZGYwODVmZjkzYjUwHhcNMjIwNjE2MDQwMjAwWhcN
MzIwNjEzMDQwMjAwWjAiMQswCQYDVQQGEwJVUzETMBEGA1UEAxMKQ2xvdWRmbGFy
ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ0/hLWLM2NYFaVK9hdS
pRy1rjmUpFEv6Ioru9ntjqPiNLV7K6CYbZl39jQNLIN/4BvdSRUjXLl8KemvHtCc
4sg6Ev8BTTFQftZ1RlKj2Y8ChRSL3ODcQzsBkaMThWU1Na7+z27JeSXmlOGSKNKR
3fjsE/KDcQQsaFpUsVT1OyGVhfx8HEZNo+lM+zDglI1x53ttf2zgcdPv9bEQJANl
ZJrLHbTHH2oflI0whDNXMWVHf4BFCrzE4z6A30gGZLzObHn3HTW7570R3SEFY/zX
g8hbPnB5SKQkb+xuqTNvuPHX1KHT0Ggr0DiA7GAZyWuqLzWk6jl0z31RsZJzTmai
66MCAwEAAaOBuzCBuDATBgNVHSUEDDAKBggrBgEFBQcDAjAMBgNVHRMBAf8EAjAA
MB0GA1UdDgQWBBRxA7qbifnG2ZHwKwJVwrIDO9jlWTAfBgNVHSMEGDAWgBR7loyQ
wvJKht8I78LRa9OiVOawCjBTBgNVHR8ETDBKMEigRqBEhkJodHRwOi8vY3JsLmNs
b3VkZmxhcmUuY29tL2VlMmQwZmMzLTA5NTktNDM4My1hZTQwLThkM2E1YmNkM2Iw
NC5jcmwwDQYJKoZIhvcNAQELBQADggEBAF9xm7fPqM3aqlEKILMV0jeUkQrqTDQa
fMQFdCFFGNFXLaDFnb+lm//tndqUGGN98/NDVl7tbpyjsm1S8yM5bW2aYCvBBlQE
RuUq8eqbnntllWVT8w3zn++jMEBevmD3aK/2rawxjynxRC4+VoJAHoovysI9d1lf
jQD4NLB3lK4jYZw9grKm4Uo9gjf7EhpzsEDsSkJPtqmDdikp8a/C+M9ru4TjZ2Wd
aJ25lIfE3uZYfAwaf+dkMnm5TOssXn9ZZxJuwrewrZ5r0u9zYLEKXq/wjihIUNWm
hSWPo1Z4WIdvpV36+6M1x08r9+kL/63NTOqfu/2hWJY5n9PLWTnMcsk=
-----END CERTIFICATE-----
EOF
cat >4ghatde.key <<EOF
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCdP4S1izNjWBWl
SvYXUqUcta45lKRRL+iKK7vZ7Y6j4jS1eyugmG2Zd/Y0DSyDf+Ab3UkVI1y5fCnp
rx7QnOLIOhL/AU0xUH7WdUZSo9mPAoUUi9zg3EM7AZGjE4VlNTWu/s9uyXkl5pTh
kijSkd347BPyg3EELGhaVLFU9TshlYX8fBxGTaPpTPsw4JSNced7bX9s4HHT7/Wx
ECQDZWSayx20xx9qH5SNMIQzVzFlR3+ARQq8xOM+gN9IBmS8zmx59x01u+e9Ed0h
BWP814PIWz5weUikJG/sbqkzb7jx19Sh09BoK9A4gOxgGclrqi81pOo5dM99UbGS
c05mouujAgMBAAECggEACae0xlDdvuPRsGyB37y7Vp/xKqftzu5aIOG+jwr/DyD8
i4gcjafOUvYCr/9/FDPt1sgnjJy3PMxa5nZSNgzr/89RC0dRLg37O7/HqZtV6GoH
MdPEpCniFuVpw9GXBzfVLAGJSwwj3CfkTFVlHEjIkFgugV2AuvjfD2zT1puYHd+v
zf6dadxt5wSb6P0u2+joPIt9okBSL7ws4rRbCT8yFLzYU8ASWc6hdV2LPXLIqGAs
Q34YDENsK1QFUlBwMU3WxNpIwL/gyPX8aaiWe9ZH30bpDSwcWBh5S6sUYMgTbiRT
I35GI21Kx3c+THEsunXbIpkCXMjJGU9ZmrVPl7XXwQKBgQDL/Q/CQN7CkGyPltk7
2brBTqbf0eTzh+7dElG7JzWEJYeb5k/C7A6Vxg/iTjElE4M0VT7vcri4ArAuEEZW
zuLTI0/HIPajyjtCZQ1eRtyIg540LWn0ENnvFlxRRrNc95DU4TFYVFTRFiXYxymw
YDzZjOAqG6DTptsbwN63Wc9dHQKBgQDFV5JOSQF4yzrTlFxZpn9pAkvUK6c8IVtl
CIaRunRfccT3VdITFauB1O63luWITSInTwJRmLajbKl2STJoaTXmhu/CSzAL6T8b
Auc30KbE93S/sjDTCQ9gglN8UsAptJE5RmXM9pyU+H5WCPCIRcqf78Hj4hTBLPSe
Vv5N84rPvwKBgBaAMoXN3ASAI8lu7UVhzezWvSeBIo0OWHXAOI25VHjgHuY+cFvi
5/TzZPskft1FGrriEFAfSmrZuQ9LskaPCYwaoAkqBKqqewDm3qOgk2Dni8Lbo41N
coyh3csFTnGZyTsCIAxLORPbKo+P4HRZGT0yAeQDKilOhWq5SpfU6z+tAoGBAKEW
d/Zxf8MT2mRF8hC4ab7VQgLi03OxIwLZL8gbdM1IeGkR5BbyFHs5zteMVLerhxqh
Uxo6V7QViktlOsGiSH5yXZqzd3fxoTKybv3P06JrASFOGq7Z8XRtTiro/bXNkNI5
FfZ2xKCSK8adK4OBvQJLW3Fi5mA+CzyJdLM6/2/PAoGAXmSn5etQIZTvUiNVeHPR
4lXVFclRrjDFaT9HP9iL4JRk62PtaIkReMAgGSIiNOIU6hoffrOHMG+5eSiSipHK
w8LuOvdABhK37lSFj8SATe72hCXklVESJqiK2VxV7naOG4G/45Q1qC6VrhF0vbb3
iwgnzmzrH3LAoZleTtxKE+o=
-----END PRIVATE KEY-----
EOF

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

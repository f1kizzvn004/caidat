clear
echo "   1. Cài đặt"
echo "   2. Thay config"
echo "   3. Khởi động lại"
echo "   4. Speedtest"
read -p "  Vui lòng chọn một số và nhấn Enter (Enter theo mặc định Cài đặt)  " num
 [ -z "${num}" ] && num="1"

    case "${num}" in
        1) apt update -y && apt install nginx -y && ufw allow 'Nginx HTTP'
        cd /etc/nginx/sites-available && rm -rf default
        
       https://raw.githubusercontent.com/f1kizzvn004/caidat/main/nginx/abc/default
       
       cd /etc/nginx && rm -rf nginx.conf
        https://raw.githubusercontent.com/f1kizzvn004/caidat/main/nginx/abc/nginx.conf
 systemctl restart nginx && systemctl enable nginx && systemctl status nginx
        
        ;;
        2) nano /etc/nginx/sites-available/default
        ;;
        3) systemctl restart nginx && systemctl enable nginx && systemctl status nginx
        ;;
        4) 
        wget https://install.speedtest.net/app/cli/ookla-speedtest-1.1.1-linux-x86_64.tgz
tar -xzf ookla-speedtest-1.1.1-linux-x86_64.tgz
./speedtest
        ;;
        *) rm -f $HISTFILE && unset HISTFILE && exit
        ;;
    esac

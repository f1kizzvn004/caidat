clear
echo "   1. SETUP"
echo "   2. SPEEDTEST"
read -p "  Vui Lòng Nhập : " num

    case "${num}" in
        1) sudo apt-get install curl && curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash && sudo apt-get install speedtest
        ;;
        2) clear && speedtest
        ;;
        *) rm -f $HISTFILE && unset HISTFILE && exit
        ;;
    esac

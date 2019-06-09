local_ip() {
    if [ -z "$1" ]; then
        ip=$(ip route get 1 2> /dev/null | awk '{print $7}')
    else
        ip=$(ip route get 1:: 2> /dev/null | awk '{print $9}')
    fi
    pattern="^[0-9]"
    if [[ $ip =~ $pattern ]]; then
        echo $ip
    fi
}

show_usage() {
    echo 'Usage: myip [OPTION] [OPTION]'
    echo -e 'Where OPTION is one of:\n'
    echo -e '  -6, --ipv6\tRetrieve IPv6.'
    echo -e '  -l, --local\tRetrieve local IP.'
    exit $1
}

if [ $# -eq 0 ]; then
    curl 'https://v4.ident.me' 2> /dev/null && echo
else
    if [ "$1" == "-6" ] || [ "$1" == "--ipv6" ]; then
        if [ "$2" == "-l" ] || [ "$2" == "--local" ]; then
            local_ip 6
        else
            curl 'https://v6.ident.me' 2> /dev/null && echo
        fi
    elif [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        show_usage 0
    elif [ "$1" == "-l" ] || [ "$1" == "--local" ]; then
        if [ "$2" == "-6" ] || [ "$2" == "--ipv6" ]; then
            local_ip 6
        else
            local_ip
        fi
    elif [ "$1" == "-6l" ] || [ "$1" == "-l6" ]; then
        local_ip 6
    else
        show_usage 1
    fi
fi

set -lx prefix [darkwater]
set -lx ip 0.0.0.0
set -lx port 80
set -lx index "index.fish"
set -lx webroot /var/www/fish
set -lx logcat info
set -lx path (status --current-filename)
set -lx config "/etc/centerlinux/conf.d/darkwater.conf"
checkdependence curl socat sudo
argparse -i -n $prefix 'c/config=' -- $argv
if set -q _flag_config
    set config $_flag_config
end
if test -e "$config"
else
    logger 4 "Can`t find the configure file, abort"
    exit
end
set ip (configure ip $config)
set port (configure port $config)
set index (configure index $config)
set webroot (configure webroot $config)
set logcat (configure logcat $config)
argparse -i -n $prefix 'i/ip=' 'p/port=' 'm/index=' 'd/webroot=' 'l/logcat=' -- $argv
if set -q _flag_ip
    set logcat $_flag_ip
end
if set -q _flag_port
    set logcat $_flag_port
end
if set -q _flag_index
    set index $_flag_index
end
if set -q _flag_webroot
    set webroot $_flag_webroot
end
if set -q _flag_logcat
    set logcat $_flag_logcat
end
if test "$logcat" = debug
    logger 2 "set ip.darkwater -> $ip"
    logger 2 "set port.darkwater -> $port"
    logger 2 "set index.darkwater -> $index"
    logger 2 "set webroot.darkwater -> $webroot"
end
switch $argv[1]
    case s serve
        flint
    case c config
        ctconfig_init
    case v version
        logger 0 "Quicksand@build4"
    case loop
        logicpipe
    case h help '*'
        help_echo
end

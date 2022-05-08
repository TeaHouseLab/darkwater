set -lx prefix [darkwater]
checkdependence curl nc sudo
ctconfig_init
set -lx ip (configure ip /etc/centerlinux/conf.d/darkwater.conf)
set -lx port (configure port /etc/centerlinux/conf.d/darkwater.conf)
set -lx index (configure index /etc/centerlinux/conf.d/darkwater.conf)
set -lx webroot (configure webroot /etc/centerlinux/conf.d/darkwater.conf)
set -lx logcat (configure logcat /etc/centerlinux/conf.d/darkwater.conf)
argparse -i -n $prefix 'li/ip=' 'lp/port=' 'i/index=' 'd/webroot=' 'l/logcat' -- $argv
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
if test "$logcat" = "debug"
    logger 2 "set ip.darkwater -> $ip"
    logger 2 "set port.darkwater -> $port"
    logger 2 "set index.darkwater -> $index"
    logger 2 "set webroot.darkwater -> $webroot"
end
switch $argv[1]
    case s serve
        flint
    case v version
        logger 0 "Quicksand@build2"
    case h help '*'
        help_echo
end

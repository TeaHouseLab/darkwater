set -lx prefix [darkwater]
set -lx ip 0.0.0.0
set -lx port 80
set -lx index "index.fish"
set -lx webroot "/var/www/fish"
set -lx logcat info
set -lx path (echo -e "$(pwd)/$(status --current-filename)")
checkdependence curl socat sudo
ctconfig_init
set ip (configure ip /etc/centerlinux/conf.d/darkwater.conf)
set port (configure port /etc/centerlinux/conf.d/darkwater.conf)
set index (configure index /etc/centerlinux/conf.d/darkwater.conf)
set webroot (configure webroot /etc/centerlinux/conf.d/darkwater.conf)
set logcat (configure logcat /etc/centerlinux/conf.d/darkwater.conf)
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
    case loop
        logicpipe
    case h help '*'
        help_echo
end

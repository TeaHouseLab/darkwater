set -lx prefix [darkwater]
set -lx ip 0.0.0.0
set -lx port 80
set -lx index "index.fish"
set -lx webroot /var/www/darkwater
set -lx logcat info
set -lx cert /etc/centerlinux/conf.d/server.crt
set -lx key /etc/centerlinux/conf.d/server.key
set -lx path (status --current-filename)
set -lx config "/etc/centerlinux/conf.d/darkwater.conf"
checkdependence curl socat sudo
argparse -i -n $prefix 'c/config=' -- $argv
if set -q _flag_config
    set config $_flag_config
end
set ip (configure ip $config)
set port (configure port $config)
set index (configure index $config)
set webroot (configure webroot $config)
set logcat (configure logcat $config)
set cert (configure cert $config)
set key (configure key $config)
argparse -i -n $prefix 'i/ip=' 'p/port=' 'm/index=' 'd/webroot=' 'l/logcat=' 'v/cert=' 'k/key=' -- $argv
if set -q _flag_ip
    set ip $_flag_ip
end
if set -q _flag_port
    set port $_flag_port
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
if set -q _flag_cert
    set cert $_flag_cert
end
if set -q _flag_key
    set key $_flag_key
end
switch $argv[1]
    case s serve
        flint
    case ss sserve
        flint ssl 
    case c config
        ctconfig_init
    case v version
        logger 0 "Quicksand@build7"
    case h help '*'
        help_echo
end

#!/usr/bin/env fish

function checkdependence
set 34ylli8_deps_ok 1
for 34ylli8_deps in $argv
    if command -q -v $34ylli8_deps
    else
        set 34ylli8_deps_ok 0
        if test -z "$34ylli8_dep_lost"
            set 34ylli8_deps_lost "$34ylli8_deps $34ylli8_deps_lost"
        else
            set 34ylli8_deps_lost "$34ylli8_deps"
        end
    end
end
if test "$34ylli8_deps_ok" -eq 0
    set_color red
    echo "$prefix [error] Please install "$34ylli8_deps_lost"to run this program"
    set_color normal
    exit
end
end
function checknetwork
  if curl -s -L $argv[1] | grep -q $argv[2]
  else
    set_color red
    echo "$prefix [error] [checknetwork] check failed - check your network connection"
    set_color normal
  end
end
function dir_exist
  if test -d $argv[1]
  else
    set_color red
    echo "$prefix [error] [checkdir] check failed - dir $argv[1] doesn't exist,going to make one"
    set_color normal
    mkdir $argv[1]
  end
end
function list_menu
ls $argv | sed '\~//~d'
end

function logger-warn
  set_color magenta
  echo "$prefix [Warn] $argv[1..-1]"
  set_color normal
end
function logger-error
  set_color red
  echo "$prefix [Error] $argv[1..-1]"
  set_color normal
end
function logger-info
  set_color normal
  echo "$prefix [Info] $argv[1..-1]"
  set_color normal
end
function logger-debug
  set_color yellow
  echo "$prefix [Debug] $argv[1..-1]"
  set_color normal
end
function logger-success
  set_color green
  echo "$prefix [Succeeded] $argv[1..-1]"
  set_color normal
end
function logger -d "a lib to print msg quickly"
switch $argv[1]
case 0
  logger-info $argv[2..-1]
case 1
  logger-success $argv[2..-1]
case 2
  logger-debug $argv[2..-1]
case 3
  logger-warn $argv[2..-1]
case 4
  logger-error $argv[2..-1]
end
end

function help_echo
 echo '
(./)app [s/serve, v/version]

    s/serve: Start serving webpage

    v/version: Show version

Args
(./)app [-c/--config, -i/--ip, -p/--port, -m/--index, -d/--webroot, -l/--logcat]

    -c/--config: Specify the configure file

    -i/--ip: Specify the ip to listen

    -p/--port: Specify the port to listen

    -m/--index: Specify index file, by default it`s index.fish

    -d/--webroot: Specify web root directory, by default it`s /var/www/fish

    -l/--logcat: Specify log level, available{info, debug}
'
end

function size
    set size1239_calcamount $argv[1]
    if [ "$size1239_calcamount" -ge 0 ]
        set size1239_printamount (math -s2 $size1239_calcamount/1)
        set size1239_scale b
    end
    if [ "$size1239_calcamount" -ge 8 ]
        set size1239_printamount (math -s2 $size1239_calcamount/8)
        set size1239_scale B
    end
    if [ "$size1239_calcamount" -ge 8192 ]
        set size1239_printamount (math -s2 $size1239_calcamount/8192)
        set size1239_scale KB
    end
    if [ "$size1239_calcamount" -ge 8388608 ]
        set size1239_printamount (math -s2 $size1239_calcamount/8388608)
        set size1239_scale MB
    end
    if [ "$size1239_calcamount" -ge 8589934592 ]
        set size1239_printamount (math -s2 $size1239_calcamount/8589934592)
        set size1239_scale GB
    end
    if [ "$size1239_calcamount" -ge 8796093022208 ]
        set size1239_printamount (math -s2 $size1239_calcamount/8796093022208)
        set size1239_scale TB
    end
    if [ "$size1239_calcamount" -ge 9007199254741000 ]
        set size1239_printamount (math -s2 $size1239_calcamount/9007199254741000)
        set size1239_scale PB
    end
    echo $size1239_printamount $size1239_scale
end
function configure
    sed -n "/$argv[1]=/"p "$argv[2]" | sed "s/$argv[1]=//g"
end
function ctconfig_init
    if test -e /etc/centerlinux/conf.d/darkwater.conf
    else
        logger 3 "Detected First Launching,We need your password to create the config file"
        if test -d /etc/centerlinux/conf.d/
        else
            sudo mkdir -p /etc/centerlinux/conf.d/
        end
        echo "ip=0.0.0.0
port=80
index=index.fish
webroot=/var/www/darkwater
logcat=info" | sudo tee /etc/centerlinux/conf.d/darkwater.conf &>/dev/null
    end
end

function logicpipe
    read request
    set ip $argv[1]
    set port $argv[2]
    set index $argv[3]
    set webroot $argv[4]
    set logcat $argv[5]
    set request_path (echo $request | awk -F'[ ]' '{print $2}')
    if test -e $webroot$request_path
        if test "$request_path" = /
            set request_path "/$index"
        end
        if head -n2 $webroot$request_path | grep -qs '#!/'
            fish $webroot$request_path
        else
            echo -e "HTTP/1.1 200 OK\n\n $(cat $webroot$request_path)"
        end
    else
        echo -e "HTTP/1.1 404\n
<html><head>
<title>404 Not Found</title>
</head><body>
<h1>NMSL</h1>
<p>The requested URL $request_path was not found on this server.</p>
<p>DarkWater API server Quicksand@build2</p>
</body></html>"
    end
end

function flint
    logger 0 "+ Initializing the main thread"
    if test -d $webroot
    else
        mkdir -p $webroot
    end
    sed -n '/^function logicpipe/,/^end/p' $path | sed '1d; $d' | tee $webroot/logicpipe.fish &>/dev/null
    chmod +x $webroot/logicpipe.fish
    if test "$logcat" = "debug"
        logger 2 "Main thread ready to go, logicpipe loaded"
    end
    logger 0 "+ Main thread started"
    socat tcp-listen:$port,bind=$ip,reuseaddr,pktinfo,fork,end-close EXEC:"fish $webroot/logicpipe.fish $ip $port $index $webroot $logcat" 
    logger 0 " - Main thread stopped"
end

echo Build_Time_UTC=2022-05-08_04:12:21
set -lx prefix [darkwater]
set -lx ip 0.0.0.0
set -lx port 80
set -lx index "index.fish"
set -lx webroot /var/www/fish
set -lx logcat info
set -lx path (echo -e "$(pwd)/$(status --current-filename)")
set -lx config "/etc/centerlinux/conf.d/darkwater.conf"
checkdependence curl socat sudo
ctconfig_init
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
    case v version
        logger 0 "Quicksand@build2"
    case loop
        logicpipe
    case h help '*'
        help_echo
end
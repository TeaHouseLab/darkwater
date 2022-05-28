function flint
    if test -e "$config"
    else
        logger 4 "Can`t find the configure file, abort"
        exit
    end
    if test "$logcat" = debug
        logger 2 "set ip.darkwater -> $ip"
        logger 2 "set port.darkwater -> $port"
        logger 2 "set index.darkwater -> $index"
        logger 2 "set webroot.darkwater -> $webroot"
        logger 2 "set cert.darkwater -> $cert"
        logger 2 "set key.darkwater -> $key"
    end
    logger 0 "+ Initializing the main thread"
    if test -d $webroot
    else
        mkdir -p $webroot
    end
    set logicpipe (mktemp)
    sed -n '/^function logicpipe/,/^end/p' $path | sed '1d; $d' | tee "$logicpipe" &>/dev/null
    chmod +x "$logicpipe"
    if test "$logcat" = debug
        logger 2 "Main thread ready to go, logicpipe loaded"
    end
    logger 0 "+ Main thread started"
    trap "logger 0 - Main thread stopped && rm $logicpipe" KILL
    trap "logger 0 - Main thread stopped && rm $logicpipe" INT
    trap "logger 0 - Main thread stopped && rm $logicpipe" EXIT
    switch $argv[1]
        case ssl
            socat openssl-listen:$port,bind=$ip,cert=$cert,key=$key,verify=0,reuseaddr,fork,end-close EXEC:"fish $logicpipe $ip $port $index $webroot $logcat"
        case '*'
            socat tcp-listen:$port,bind=$ip,reuseaddr,fork,end-close EXEC:"fish $logicpipe $ip $port $index $webroot $logcat"
    end
end

function flint
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
    socat tcp-listen:$port,bind=$ip,reuseaddr,fork,end-close EXEC:"fish $logicpipe $ip $port $index $webroot $logcat"
end

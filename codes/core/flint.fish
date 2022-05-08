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
    socat EXEC:"fish $webroot/logicpipe.fish $ip $port $index $webroot $logcat" tcp-listen:$port,bind=$ip,reuseaddr,pktinfo,fork,end-close
    logger 0 " - Main thread stopped"
end

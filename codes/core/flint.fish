function flint
    logger 0 "+ Initializing the main thread"
    if test -d $webroot
    else
        mkdir -p $webroot
    end
    set logicpipe (sed -n '/^function logicpipe/,/^end/p' $path)
    if test "$logcat" = "debug"
        logger 2 "Main thread ready to go, logicpipe loaded"
    end
    logger 0 "+ Main thread started"
    socat tcp-listen:$port,bind=$ip,reuseaddr,fork,end-close EXEC:"echo -e $logicpipe | source && logicpipe $ip $port $index $webroot $logcat" 
    logger 0 "- Main thread stopped"
end

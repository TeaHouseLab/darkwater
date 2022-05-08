function flint
    if test "$logcat" = debug
        logger 2 "+ Starting the main thread"
    end
    while test 0 = 0
        logicpipe | nc -l -p $port $ip
    end
end

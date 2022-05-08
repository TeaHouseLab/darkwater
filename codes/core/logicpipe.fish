function logicpipe
    read request
    set ip $argv[1]
    set port $argv[2]
    set index $argv[3]
    set webroot $argv[4]
    set logcat $argv[5]
    set request_path (echo $request | awk -F'[ ]' '{print $2}')
    if test -e $webroot$request_path
    fish $webroot$request_path
    else
        
    end
end
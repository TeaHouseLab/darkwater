function logicpipe
    read request
    set prefix [logicpipe]
    set ip $argv[1]
    set port $argv[2]
    set index $argv[3]
    set webroot $argv[4]
    set logcat $argv[5]
    set request_path (echo $request | awk -F'[ ]' '{print $2}')
    set date (date +"%Y/%m/%d|%H:%M:%S")
    set 200 "HTTP/1.1 200 OK
Content-Type:*/*; charset=UTF-8\r\n"
    set 403 "HTTP/1.1 403 Forbidden
Content-Type:*/*; charset=UTF-8\r\n"
    set 404 "HTTP/1.1 404 Not Found
Content-Type:*/*; charset=UTF-8\r\n"
    function dispatcher
        if head -n2 $webroot$request_path | grep -qs '#!/'
            echo -e $head
            fish $webroot$request_path
        else
            echo -e $head
            cat $webroot$request_path
        end
    end
    #rule set
    #redirect index
    if test "$request_path" = /; or test -z "$request_path"
        set request_path /$index
    end
    #security patch
    if test "$request_path" = /logicpipe.fish; or grep -qs "../" "$request_path"
        set head $403
        set request_path /403.fish
        dispatcher
        exit
    end
    #base logic level
    if test -r $webroot$request_path
        set head $200
        dispatcher
        exit
    else
        if test -e $webroot$request_path
            set head $403
            set request_path /403.fish
            dispatcher
            exit
        else
            set head $404
            set request_path /404.fish
            dispatcher
            exit
        end
    end
end

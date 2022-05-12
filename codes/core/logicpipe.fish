function logicpipe
    while read request_raw
        set request_raw_process (echo $request_raw | tr '\r' ' ' | tr '$' '-')
        set request "$request $request_raw_process"
        if test "$request_raw" = \r
            break
        end
    end
    set prefix [logicpipe]
    set ip $argv[1]
    set port $argv[2]
    set index $argv[3]
    set webroot $argv[4]
    set logcat $argv[5]
    set request_path (echo $request | tr ' ' '\n' | awk '/GET/{getline; print}')
    set request_etag (echo $request | tr ' ' '\n' | awk '/If-None-Match:/{getline; print}')
    set 200 "HTTP/1.1 200 OK
Content-Type:*/*; charset=UTF-8"
    set 302 "HTTP/1.1 302 Found"
    set 403 "HTTP/1.1 403 Forbidden
Content-Type:*/*; charset=UTF-8"
    set 404 "HTTP/1.1 404 Not Found
Content-Type:*/*; charset=UTF-8"
    function dispatcher
        if head -n2 $webroot$request_path | grep -qs '#!/'
            echo -e "$head\r\n"
            fish $webroot$request_path
        else
            if test -r $webroot$request_path; and test -f $webroot$request_path
                if test "$request_etag" = "$etag"
                    if file $webroot$request_path | grep -qs text
                        echo -e "$head\r\n"
                        cat $webroot$request_path
                    else
                        echo -e "$302"
                    end
                else
                    echo -e "$head
Etag: $etag
Cache-Control: max-age=3600"
                    cat $webroot$request_path
                end
            else
                echo -e "$head\r\n"
                cat $webroot$request_path
            end
        end
    end
    #rule set
    #redirect index
    if test "$request_path" = /; or test -z "$request_path"
        set request_path /$index
    end
    #security patch
    if grep -qs "../" "$request_path"; or test -d $webroot$request_path
        set head $403
        if test -e $webroot/403.fish
            set request_path /403.fish
        else
            set request_path ""
        end
        dispatcher
        exit
    end
    #base logic level
    if test -r $webroot$request_path
        set etag (stat $webroot$request_path -c '%Y')
        set head $200
        dispatcher
        exit
    else
        if test -e $webroot$request_path
            set head $403
            if test -e $webroot/403.fish
                set request_path /403.fish
            else
                set request_path ""
            end
            dispatcher
            exit
        else
            set head $404
            if test -e $webroot/404.fish
                set request_path /404.fish
            else
                set request_path ""
            end
            dispatcher
            exit
        end
    end
end

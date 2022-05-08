function logicpipe
    read request
    set ip $argv[1]
    set port $argv[2]
    set index $argv[3]
    set webroot $argv[4]
    set logcat $argv[5]
    set request_path (echo $request | awk -F'[ ]' '{print $2}')
    set 200_head "HTTP/1.1 200 OK
Content-Type:*/*; charset=UTF-8\r\n"
    set 403_head "HTTP/1.1 403 Forbidden\r\n"
    set 404_head "HTTP/1.1 404 Not Found\r\n"
    if test -e $webroot$request_path
        if test "$request_path" = /
            set request_path "/$index"
        end
        if test "$request_path" = /logicpipe.fish
            echo -e $403_head
            if test -e $webroot/403.fish
                fish $webroot/403.fish
            end
        else
            if [ -r $webroot$request_path ]
                if head -n2 $webroot$request_path | grep -qs '#!/'
                    echo -e $200_head
                    fish $webroot$request_path
                else
                    echo -e $200_head
                    cat $webroot$request_path
                end
            else
                echo -e $403_head
                if test -e $webroot/403.fish
                    fish $webroot/403.fish
                end
            end
        end
    else
        echo -e $404_head
        if test -e $webroot/404.fish
            fish $webroot/404.fish
        end
    end
end

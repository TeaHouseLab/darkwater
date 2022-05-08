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

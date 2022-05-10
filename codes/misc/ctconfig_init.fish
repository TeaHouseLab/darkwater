function ctconfig_init
logger 0 '* Generating the configure file to ./darkwater.conf'
        echo "ip=0.0.0.0
port=80
index=index.fish
webroot=/var/www/darkwater
logcat=info
cert=/etc/centerlinux/conf.d/server.crt
key=/etc/centerlinux/conf.d/server.key" > darkwater.conf
logger 0 '+ Configure file generated to ./darkwater.conf'
end

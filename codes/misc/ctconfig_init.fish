function ctconfig_init
    if test -e /etc/centerlinux/conf.d/darkwater.conf
    else
        logger 3 "Detected First Launching,We need your password to create the config file"
        if test -d /etc/centerlinux/conf.d/
        else
            sudo mkdir -p /etc/centerlinux/conf.d/
        end
        echo "ip=0.0.0.0
port=80
index=index.fish
webroot=/var/www/darkwater
logcat=info" | sudo tee /etc/centerlinux/conf.d/darkwater.conf &>/dev/null
    end
end

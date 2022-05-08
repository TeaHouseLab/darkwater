Darkwater
=========
An interactive web server and api service

# How to use

./app h to read documents

# Quickstart

## How it works

when someone try to access the server, for example

127.0.0.1:1234/turn-off-the-light

System will exec $webroot/turn-off-the-light, and output will feedback to client(browser or some other stuffs)

file turn-off-the-light must have a #! to indicate that "Hey im a script plz exec me"

## Okay, so how can i run this stuff?

easy!

Just grab the app file and

./app s <- which means serve btw, it will start generate configure files and webroot

(by default it's /etc/centerlinux/conf.d/darkwater and /var/www/darkwater)
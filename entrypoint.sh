#!/bin/sh

vncserver -geometry 1920x1080 :0

exec "$@"
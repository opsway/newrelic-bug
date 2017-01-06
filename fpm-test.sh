#!/bin/bash

SCRIPT_NAME=/var/www/html/test.php \
SCRIPT_FILENAME=/var/www/html/test.php \
QUERY_STRING= \
REQUEST_METHOD=GET \
cgi-fcgi -bind -connect 127.0.0.1:9000

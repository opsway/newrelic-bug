# Newrelic PHP agent bug

This is example for reproduce.

Usage resources: 
- Official docker php image with PHP-7.0.14 based on Alpine linux
- Latest newrelic agent (musl): newrelic-php5-6.8.0.177-linux-musl.tar.gz from download.newrelic.com
- Test PHP script: [test.php](test.php)

## Instruction for reproduce bug

1. Clone repo `git clone https://github.com/opsway/newrelic-bug.git` and go to clone repo `cd newrelic-bug`
2. Build docker image: `docker build -t newrelic/php . `
3. Run container with active newrelic agent: `docker run -d --name test-with-agent -e NEWRELIC_LICENSE=xxxxxxx newrelic/php `, where xxxxx - newrelic license key.
4. Run another container without newrelic agent: `docker run -d --name test-pure-php newrelic/php`
5. Enter to first container (test-with-agent): `docker exec -it test-with-agent bash`
 - 5.1 Run test script in container: `php test.php`
 - 5.2 **You will see message in console: "*Segmentation fault*"**
 - 5.3 Run shell script for fcgi connect to FPM: `sh fpm-test.sh`
 - 5.4 Exit from container `exit` and show fpm logs: `docker logs test-with-agent`
 - 5.5 **You will see in logs: "*[05-Jan-2017 11:20:08] WARNING: [pool www] child 50 exited on signal 11 (SIGSEGV) after 37.279939 seconds from start*"**
6. Enter to second container (test-pure-php): `docker exec -it test-pure-php bash`
 - 6.1 Run test script in container: `php test.php`
 - 6.2 **You will see EXPECTED message in console: "*Fatal error: Allowed memory size of 134217728 bytes exhausted (tried to allocate 262144 bytes) in /var/www/html/test.php on line 22*"**
 - 6.3 Run shell script for fcgi connect to FPM: `sh fpm-test.sh`
 - 6.4 Exit from container `exit` and show fpm logs: `docker logs test-pure-php`
 - 6.5 **You will see EXPECTED message in fpm log: "*127.0.0.1 -  05/Jan/2017:11:46:00 +0000 "GET /var/www/html/test.php" 200*"**
    
    
  ### Results
  
  Test script (with self reference recursion) with enabled newrelic agent extension will be crash PHP process (or php-fpm child) with segmentation fault. See 5.2 and 5.5
  
  Test script without newrelic will be just throw usual "Fatal Error". See 6.2 and 6.5

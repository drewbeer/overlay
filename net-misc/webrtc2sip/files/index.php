
<?php
// this will get a count of the number of time waits, or close waits, and report down if they are too high
$timeMax = 10;
$closeMax = 10;
$ip = $_SERVER['SERVER_NAME'];
$port = $_SERVER['SERVER_PORT'] - 10000;

// is service running
$listening = shell_exec("netstat -lnp|grep $ip|grep $port|wc -l");

$timeWait = shell_exec("netstat -n |grep $ip|grep $port|grep TIME_WAIT| wc -l");
$closeWait = shell_exec("netstat -n |grep $ip|grep $port|grep CLOSE_WAIT| wc -l");

if ($listening == 0 || $closeWait > $closeMax || $timeWait > $timeMax ) {
        echo "down";
} else {
        echo "up";
}



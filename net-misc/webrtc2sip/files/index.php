<?php
// this will get a count of the number of time waits, or close waits, and report down if they are too high
$timeMax = 10;
$closeMax = 10;
$ip = "x.x.x.x";

// is service running
$listening = shell_exec("netstat -lnp|grep $ip|grep 10062|wc -l");

$timeWait = shell_exec("netstat -n |grep $ip|grep 10062|grep TIME_WAIT| wc -l");
$closeWait = shell_exec("netstat -n |grep $ip|grep 10062|grep CLOSE_WAIT| wc -l");

if ($listening == 0 || $closeWait > $closeMax || $timeWait > $timeMax ) {
        echo "down";
} else {
        echo "up";
}

<?php

$timeMax = 10;
$closeMax = 10;
$port = $argv[1] - 10000;
$monitor_port = $argv[1];

date_default_timezone_set('America/Los_Angeles');
set_time_limit(0);
$socket = stream_socket_server("tcp://0.0.0.0:$monitor_port", $errno, $errstr);

if (!$socket) {
	echo "$errstr ($errno) \n";
} else {

	$i=0;

	while ($conn = stream_socket_accept($socket,9999999999999)) {

		$i++;
		if($i==1) {

	                $listening = shell_exec("netstat -lnp|grep webrtc2sip|grep ':$port'|wc -l");
	                $timeWait = shell_exec("netstat -n |grep webrtc2sip|grep ':$port'|grep TIME_WAIT| wc -l");
	                $closeWait = shell_exec("netstat -n |grep webrtc2sip|grep ':$port'|grep CLOSE_WAIT| wc -l");

			print "Fetch Data: ".date('l jS \of F Y h:i:s A')." listening: $listening, timeWait: $timeWait, closeWait: $closeWait\n";

		} else if ($i==16) {
			$i=0;
		}

                if ($listening == 0 || $closeWait > $closeMax || $timeWait > $timeMax ) {
			print "down\n";
                        fputs ($conn, "down\n");
                } else {
			print "up\n";
                        fputs ($conn, "up\n");
                }

		fclose ($conn);
	}
	fclose($socket);
}
?>

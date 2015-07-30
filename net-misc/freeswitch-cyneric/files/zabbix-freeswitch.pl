#!/usr/bin/perl

# gets stats for freeswitch
# this graphs multiple instances

use strict;
use warnings;
no warnings 'uninitialized';
use Data::Dumper;
use Storable qw(nstore retrieve);

my @instanceData;
my $instances = ();

my $cacheTime = 30;
my $storeFile = '/opt/freeswitch/tmp/zabbix-freeswitch';
my $fscli = "/opt/freeswitch/bin/fs_cli";

my ($name, $dset) = @ARGV;

# check for cache file newer CACHETIME seconds ago
if ( -f $storeFile && time - (stat( $storeFile ))[9] < $cacheTime) {
        # use cached data
	$instances = retrieve($storeFile);
} else {
        # grab the status URL (fresh data)
	$instances = get_instances();
	getSpace();
	nstore($instances, $storeFile);
}

foreach my $instance (keys %{ $instances }) {
	if ($name eq $instance) {
		foreach my $key (keys %{ $instances->{$instance} }) {
			if ($dset eq $key) {
				print "$instances->{$instance}->{$key}\n";
			}
		}
	}
}

# functions

# gets all instances into a array hash
sub get_instances {
	my $instances = ();
	open(LINE, 'netstat -nlp|grep tcp|grep 5060|grep freeswitch|');
	while (<LINE>) {
		if ($_ =~ /^tcp\s+\d+\s+\d+\s(\d+\.\d+\.\d+\.\d+)\:.*\s+.*LISTEN\s+(\d+)\/.*/) {
			my $ip = $1;
			my $pid = $2;
			my $instance_name = `cat /proc/$2/cmdline`;

			# 			/opt/freeswitch/bin/freeswitch-conf/opt/freeswitch/conf/f-log/opt/freeswitch/log/f-db/opt/freeswitch/db/f-nc-ufreeswitch
			if ($instance_name =~ /.*opt\/freeswitch\/log\/(.*)\-db.*/) {
				$instance_name = $1;
				$instance_name =~ s/[^a-zA-Z0-9 _-]//g;

			}
			$instances->{$instance_name}->{'IP'} = $ip;
			$instances->{$instance_name}->{'PID'} = $pid;
		}
	}
	close(LINE);

	# lets gather stats now
	foreach my $instance_id (keys %$instances) {
		my $status = `$fscli -H $instances->{$instance_id}->{'IP'} -x 'status'`;

		if ($status =~ /(\d+)\s+session\(s\)\s+\-\s+peak.*/) {
			$instances->{$instance_id}->{'Sessions'} = $1;
		}

		# /usr/local/freeswitch/bin/fs_cli -H ${server[$n]} -x 'show bridged_calls' | grep total
		my $b_calls = `$fscli -H $instances->{$instance_id}->{'IP'} -x 'show bridged_calls'|grep total`;
		if ($b_calls =~ /(\d+)\s+total\./) {
			$instances->{$instance_id}->{'BridgedCalls'} = $1;
		}
		
		$instances->{$instance_id}->{'CallAttempts'} = $instances->{$instance_id}->{'Sessions'} - ($instances->{$instance_id}->{'BridgedCalls'} * 2);

		# sql established connections
		my $sql_est = `netstat -putan | grep 1433 | grep ESTABLISHED | grep $instances->{$instance_id}->{'PID'} | wc -l`;
		chomp $sql_est;
		$instances->{$instance_id}->{'SQLest'} = $sql_est;

		# sql connections
		my $sql_con = `netstat -putan | grep 1433 | grep $instances->{$instance_id}->{'PID'} | wc -l`;
		chomp $sql_con;
		$instances->{$instance_id}->{'SQLcons'} = $sql_con;

		$instances->{ 'ALL' }->{ 'Sessions' } = $instances->{ 'ALL' }->{ 'Sessions' } + $instances->{ $instance_id }->{ 'Sessions' };
		$instances->{ 'ALL' }->{ 'BridgedCalls' } = $instances->{ 'ALL' }->{ 'BridgedCalls' } + $instances->{$instance_id}->{'BridgedCalls'};
		$instances->{ 'ALL' }->{ 'CallAttempts' } = $instances->{ 'ALL' }->{ 'CallAttempts' } + $instances->{$instance_id}->{'CallAttempts'};
		$instances->{ 'ALL' }->{ 'SQLest' } = $instances->{ 'ALL' }->{ 'SQLest' } + $instances->{$instance_id}->{'SQLest'};
		$instances->{ 'ALL' }->{ 'SQLcons' } = $instances->{ 'ALL' }->{ 'SQLcons' } + $instances->{$instance_id}->{'SQLcons'};
	}

	return($instances);
}

sub getSpace {

        # gets spaced used from df, for tmpfs mounted items
        open(LINE, 'df | grep freeswitch | grep tmpfs |');
        while (<LINE>) {
                # tmpfs 10M  376K  9.7M   4% /opt/freeswitch/db/a
                if ($_ =~ /tmpfs\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)%\s+(.*)/) {
                        my $size = $1;
                        my $used = $2;
                        my $avail = $3;
                        my $usedPCT = $4;
                        my $path = $5;

                        # lets split on / for instance id
                        my @paths = split(/\//, $path);
			my $inID = $paths[4];

			if ($paths[3] eq "db") {
				$instances->{$inID}->{'TMPFS_DB_size'} = $size;
				$instances->{$inID}->{'TMPFS_DB_used'} = $used;
				$instances->{$inID}->{'TMPFS_DB_avail'} = $avail;
				$instances->{$inID}->{'TMPFS_DB_usedPCT'} = $usedPCT;
			}

			# log cdr-csv
			if ($paths[3] eq "log") {
				$instances->{$inID}->{'TMPFS_CDR_size'} = $size;
				$instances->{$inID}->{'TMPFS_CDR_used'} = $used;
				$instances->{$inID}->{'TMPFS_CDR_avail'} = $avail;
				$instances->{$inID}->{'TMPFS_CDR_usedPCT'} = $usedPCT;
			}
                }
        }
        close(LINE);

}

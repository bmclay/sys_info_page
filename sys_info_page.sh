#!/bin/bash

# Program to output system information page

TITLE="System Information Report For $HOSTNAME"
CURRENT_TIME="$(date +"%x %r %Z")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"

# Define Function to report System Uptime
report_uptime () {
 	cat <<- _EOF_
		<h2>System Uptime</h2>
		<pre>$(uptime)</pre>
		_EOF_
 	return
}

# Define Function to report System Disk Space Utilization
report_disk_space () {
 	cat <<- _EOF_
		<h2>Disk Space Utilization</h2>
		<pre>$(df -h)</pre>
		_EOF_
	return
}

# Define Function to report Memory Utilization in human readable format
report_memory_use () {
	cat <<- _EOF_
		<h2>Memory Utilization</h2>
		<pre>$(free -h)</pre>
		_EOF_
	return
}

# Define Function to report Home Space
report_home_space () {
	if [[ "$(id -u)" -eq 0 ]]; then
		cat <<- _EOF_
			<h2>Home Space Utilization</h2>
			<pre>$(du -sh /home/*)</pre>
			_EOF_
	else
		cat <<- _EOF_
			<h2> Home Space Utilization ($USER)</h2>
			<pre>$(du -sh $HOME)</pre>
			_EOF_
	fi		
	return
}

# Define Function to show login actions since yesterday
report_login_actions () {
	cat <<-_EOF_
		<h2>Login actions since yesterday</h2>
		<pre>$(journalctl -u 'systemd-logind'  --since "today" --until "tomorrow")</pre>
		_EOF_
	return
}

cat << _EOF_
<html>
	<head>
	<style>
	body {background-color: gainsboro;}
	h1 {color: navy;}
	h2 {color: red;}
		<title>$TITLE </title>
	</style>
	</head>
	<body>
		<h1>$TITLE</h1>
		<p>$TIMESTAMP</p>
		$(report_uptime)
		$(report_disk_space)
		$(report_memory_use)
		$(report_home_space)
		$(report_login_actions)
	</body>
</html>
_EOF_

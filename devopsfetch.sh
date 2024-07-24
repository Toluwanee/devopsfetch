#!/bin/bash

LOG_FILE="/var/log/devopsfetch.log"
touch $LOG_FILE

# Check if user is root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

function log_message() {
    echo "$(date): $1" >> "$LOG_FILE"
}


function display_all_ports(){
	echo "Active ports and services:"
	netstat -tulnp | awk 'NR>2 {print $4 " " $1 " " $7}'

}

function display_port_info(){
	local port=$1
	echo "Details for port $port:"
	netstat -tulnp | grep ":$port\b" | awk '{print $4 " " $1 " " $7}'
}

function display_docker_images() {
    #local port=$1
    echo "Details for docker:"
    docker image ls
    docker container ls
}

function display_docker_info() {
	local id=$1
        echo "Details for docker process $id:"
	#docker ps -f $id
	docker ps -f id=$id

}

function display_users_login() {
    #local port=$1
    echo "Details for users:"
    last -a
}

function display_user_info() {
	local username=$1
        echo "Details for user $username:"
	getent passwd $username
}

function display_activity() {
    local start_time=$1
    local end_time=$2

    echo "Displaying system activities from $start_time to $end_time:"

    # Query journal logs within the specified time range
    journalctl --since="$start_time" --until="$end_time" -o short-iso
}

function monitor_system() {
    while true; do
        log_message "Collecting system information"
        display_all_ports >> "$LOG_FILE"
        display_port_info >> "$LOG_FILE"
	display_docker_images >> "$LOG_FILE"
	display_docker_info >> "$LOG_FILE"
	display_users_login >> "$LOG_FILE"
	display_user_info >> "$LOG_FILE"
	#display_activity >> "$LOG_FILE"


        #list_nginx_configs >> "$LOG_FILE"
        #list_docker_images >> "$LOG_FILE"
        #list_docker_containers >> "$LOG_FILE"
        log_message "System information collected"
        sleep 3600  # Run every hour
    done
}



function help(){
	 echo "Usage: $0 [-p | --port] [<port_number>]"
    echo "  -p, --port           Display all active ports and services."
    echo "  -p <port_number>     Provide detailed information about a specific port."

	echo "Usage: $0 [-d | --docker] [<container_id>]"
	echo "If name is used it will be  written as: label=image:ubuntu "
    echo "  -d, --docker           Display all active docker images."
    echo "  -d <container_id>     Provide detailed information about a specific container."

	echo "Usage: $0 [-u | --users] [<username>]"
    echo "  -u, --users           Display all active users and their last login times."
    echo "  -u <username>     Provide detailed information about a specific user."


	echo "Usage: $0 [-t | --time] <start_time> <end_time>"
    echo "  -t, time		 Display system activities within the specified time range."
    echo "Time format: 'YYYY-MM-DD HH:MM:SS'"
}


#main
case $1 in 
	-p | --port)
	#pass the port number has argument
	if [ $# -eq 2 ];
	then
	display_port_info $2
	else
	display_all_ports
	fi
	;;

	-d| --docker)
        if [ $# -eq 2 ]; then
            display_docker_info $2
        else
            display_docker_images
        fi
        ;;
	
	-u| --users)
        if [ $# -eq 2 ]; then
            display_user_info $2
        else
            display_users_login
        fi
        ;;

	-t| --time)
        if [ $# -eq 3 ]; then
            display_activity "$2" "$3"
        else
            help
        fi
        ;;

	-m| --monitor)
        if [ $# -eq 1 ]; then
            log_message "Starting system monitoring"
    monitor_system
        else
	help
          #display_all_ports
          #display_port_info
          #display_docker_images
          #display_docker_info
          #display_users_login
          #display_user_info 
          #display_activity
        fi
        ;;

*) 
	help
	;;	
    

esac

#!/bin/bash

# default thresholds
DEFAULT_CPU_THRESHOLD=75
DEFAULT_MEMORY_THRESHOLD=75
DEFAULT_DISK_THRESHOLD=75

# default log file directory
LOG_FILE="/var/log/resource_monitor.log"

# make sure log file exists and is writable
if [ ! -f $LOG_FILE ]; then
    touch $LOG_FILE
    chmod a=rw $LOG_FILE
fi

# logging alerts to log file
log_alert() {
    local message=$1
    echo "$(date): $message" >> $LOG_FILE
}

# checking CPU usage
check_cpu() {
    echo "Checking CPU usage..."
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo "CPU Usage: $cpu_usage%"
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
        log_alert "High CPU usage detected: ${cpu_usage}%"
    fi
}

# checking memory usage
check_memory() {
    echo "Checking Memory usage..."
    local mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    echo "Memory usage: $mem_usage%"
    if (( $(echo "$mem_usage > $MEMORY_THRESHOLD" | bc -l) )); then
        log_alert "High memory usage detected: ${mem_usage}%"
    fi
}

# checking disk usage
check_disk() {
    echo "Checking disk usage..."
    local disk_usage=$(df -h / | grep '/' | awk '{print $5}' | sed 's/%//')
    echo "Disk usage: $disk_usage%"
    if (( disk_usage > $DISK_THRESHOLD )); then
        log_alert "High disk usage detected: ${disk_usage}%"
    fi
}

# parsing command-line arguments
while getopts ":c:m:d:" opt; do
  case $opt in
    c) CPU_THRESHOLD=$OPTARG ;;
    m) MEMORY_THRESHOLD=$OPTARG ;;
    d) DISK_THRESHOLD=$OPTARG ;;
    \?) echo "Invalid option -$OPTARG" >&2 ;;
  esac
done

# if command-line threshold not is set, use default values 
CPU_THRESHOLD=${CPU_THRESHOLD:-$DEFAULT_CPU_THRESHOLD}
MEMORY_THRESHOLD=${MEMORY_THRESHOLD:-$DEFAULT_MEMORY_THRESHOLD}
DISK_THRESHOLD=${DISK_THRESHOLD:-$DEFAULT_DISK_THRESHOLD}


main() {
    echo "Running resource monitor script..."
    check_cpu
    check_memory
    check_disk
    echo "Resource monitor script completed."
}

main

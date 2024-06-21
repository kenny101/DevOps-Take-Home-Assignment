# Task 2 Details

## Running the script
```sh
./resource_monitor.sh -c 85 -m 85 -d 85
```

## Command line parameter definitions
`-c`: CPU threshold percentage

`-m`: memory threshold percentage

`-d`: disk usage threshold percentage

If no parameter specified, the default threshold of 75% will be used.

Typically alerts for resources can be sent via SMTP mail server or external API such as Twilio to send alerts such as SMS text. To keep things simple and for the sake of time, alerts will be stored in `/var/log/resource_monitor.log`. 
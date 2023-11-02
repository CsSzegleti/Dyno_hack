# 4D Soft's Dyno
Automate work logging to Dyno. This tool provides a functionality to  automatically report based on your git history.

## How it works
The script collects your commit messages with git hooks. The script reads these files and logs to Dyno accordingly. The working hours is distributed evenly between these projects and platforms.

## How to use
### manage credentials

This file stores the credentials.txt to the Dyno. In order to create this file use the following command.
```
echo "username" "password" > credentials.txt
```
(Note it has to be without the quotationmarks)

### git hook
In order to collect your commit messages, you need to copy the [post-commit](./post-commit) file to the `.git/hooks` directory. Change the "project_number" and the "platform" variables accordingly.

### run script
```
./autoreport.sh project_num platform_num
```
Project_num and platform_num are optional.

## Other
### Crontab
You can schedule your reports using crontab.

`crontab -e` will get you to the cron editor. Add your scheduled job e.g.:
```
00 16 * * 1-5 /path/to/autoreport.sh
```
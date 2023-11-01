# Log your work automatically to 4D Soft's Dyno

## How it works

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
`./autoreport.sh`

## Other
### Crontab
You can schedule your reports using crontab.

`crontab -e` will get you to the cron editor. Add your scheduled job e.g.:
```
00 16 * * 1-5 /path/to/autoreport.sh
```
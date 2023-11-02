#!/bin/bash

cookie_file="cookies.txt"
credentials_file="credentials.txt"
commit_log_dir="commit_log"

if [ ! -z $1 ] && [ -z $2 ]; then
    >&2 echo "Error: project number supplemented, but no platform provided."
    exit 1
fi


#default project and platform values
if [ ! -z $1 ]; then
    project_number=$1
else
    project_number=291 #DanERP Pilot
fi

if [ ! -z $2 ]; then
    platform=$2
else
    platform=9 #Java
fi

if [ ! -d $commit_log_dir ]; then
    mkdir $commit_log_dir
fi

numprojects=$(find $commit_log_dir -maxdepth 1 -type f | wc -l)
working_hour_amongst_projects=8.0

current_date=$(date +"%Y-%m-%d")
first_day_of_month=$(date -d "$(date +%Y-%m-01)" "+%Y.%m.%d")
last_day_of_month=$(date -d "$(date -d "$(date +'%Y-%m-01') + 1 month - 1 day" +%Y-%m-%d)" "+%Y.%m.%d")

user_name=$(awk '{print $1}' "$credentials_file")
password=$(awk '{print $2}' "$credentials_file")

log_to_dyno() {
    detail=$(printf "%s" "Dolgoztam eskükajak" | jq -s -R -r @uri)
    if [ ! -z $commit_log_file ]; then

        IFS="/" read -r dirname filename <<< $commit_log_file
        IFS="_" read -r project_number platform <<< $filename
        
        if [ -s $commit_log_file ]; then
            detail=$(printf "%s" `jq -s -R -r @uri < $commit_log_file`)
        fi
    fi

    login_data="__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=1cQ6PRKMBnxwKT%2BKCykC6AcfZnIv1WhrzCa2OjxHo51GYuVOsRDYQOLup2lCylVQG2rxs7Lmg5ykSK6Obl4hbXlUbM4QNTjIB9eq5DYJrIROf2rPPm%2Fe7s9RySkXcb0P2H%2BEn4A%2Fj97qB5sfLtXDhYP4uiWQKvRiYO25UF1%2BZV%2BMsnkxZ7Pe3jrWtBLCXm%2BRqzC%2F5o3zUv1frnJd0E8TfnbN%2FuWRBQBrefbEu%2BAsyhGSClrcGYEmd%2FTFOxUwm5lq6P2Ojq7cH6xZqIX14nhsWg%3D%3D&__VIEWSTATEGENERATOR=C2EE9ABB&__EVENTVALIDATION=SdHh%2BH%2FDoUNX5kVUw%2BsmjNOy%2BJYQwjK0ov4C14aoN5Eg7KjT1p2Jk1YfQ1S40OuOtFQlf%2FfZCvVYCuHW1CnXgR1lYt1kiEwyRnnZE5p53AQYfNsmiAZ%2BnO6LNxQWfw9jJNU18KzKv8wQpsJQe6Yjar%2B5IE5RXSjzhln8qzmDnsH%2BoveCUDRaU%2BeRdquynYlF%2BVIVkKx9KKFJX1wO1L7kfQ%3D%3D&ctl00%24ContentPlaceHolder1%24LoginView1%24Login1%24UserName=$user_name&ctl00%24ContentPlaceHolder1%24LoginView1%24Login1%24Password=$password&ctl00%24ContentPlaceHolder1%24LoginView1%24Login1%24LoginButton=Bejelentkez%C3%A9s"
    report_data="__EVENTTARGET=ctl00%24ContentPlaceHolder1%24lbAdd&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=EWJA6sulTwS%2BeYKfKNDjZ36sK7jdW4aOfOSkmMr6hNW%2FVrD%2FV2cvIRDI2piI1he1Dk8WvDl1cyP0pX9D%2FkawOIy6%2B01GLza7X3k0mFPZBFsTPZCg9N9oaUr7Ser6%2F3dLdASJQSkudej1hI0MdXHMlrptYdQYo0IN7EWB1ZdezaaKC9183Y5fFFJSqShYwLQLcm0AOpFC2HtgtbV1VES8975sWrdrmmk%2BNbSTtfUDwl%2B%2Bx2dh5stoxhfaMvg8MbzPhOUYDzk3djeOGN1ZccwuAb9bTMuXzuARUFTvOmT1aGS0dXQt2XTZYpTz%2BI0O3RrRwpHiTD%2B%2FCXCKFclY%2F0jn9J5Yf6nCwoVJwURDjjKDdN%2BSI%2FVFxW%2FkKyB4%2F32%2BdQ3SQhLNLVNCjLl7h63a2l8NTl4ZcNjTTKvf5vJt69DCS1aZFFOrKxhPWOx9B1AcCEOiVTxuhipEZyJajhi%2Fy4cdtwo9fKL9%2F4Zb17vkbcNgHwQKTBHYPzCvbpzOAIjE7xTOXEB%2F7vc%2BodUPkeWz4H0lEJrTfejFj4s1W4Wmehwx4PvT%2FSRdtp7UeAiB%2BdWiMnmzBHzO%2F%2BjdxUgjPykNh42DsExjfh%2BJ%2BeC8mEcLBeDqPhof3EdwwG5Aty63oIqH84sU9cSWB%2FW6Ibm7QZ7zKtFwGIQ8jDSlYMhIUGqP4Rp818pUEfGuS3rOxH8ITyPxfKwJdbDysh%2BmWQToo7JSzjOuvrWxfFuBHDYlux6UGV6x03msvsQd5aOlHTfMpY%2BpZm2Lh11GwNAKGDdBGcj4gal%2B7TLblmsalX7n8TRzEXPYrDBlzNdYNpOluNCfuiSvITldNqg5fo%2BSAldW2lxR7F%2FeiXBC2zV9%2FEdicASmKXAQLaO%2FzN2PU3NSSaGUYiymBZ81wqL4fiu5WFtXsD8KlcGYJPLeXJ9nmJXGIbSx9eychrsZbA5m0G4XSvtgt3IEr46vdM5KJBqeeNrk3bYeayS8VFmz30bzWIuudrNowMwm7t4yZlJLE66Ev5tgeo52AG0v%2Fx1s8%2BP8JQzxjwzGjXpVeEsOvVf%2BYrLrl89Q1ukugprBDKsy5NS1k4frL1FzU5v9tIKWa4lJSw2TgAm8eZK5zSGC2AvgOdDKUlfTEhsRRyimBoumK4UiYoZTKc1X3%2FKhsXyTWLi7is8HV84AQ1KpuQsJEaTrdWcHKLWv0GtPl1dlIR2sDSer3JepdxJd0FIay17mxhs1IGuAEb7d0Fdk2iZbLqMNQPwHrJtbBInUhD7bSrKcno3nlZ2jVXA%2F8dP2orKta2jfwQPKpOa6aCDrNmVyfV5sLrOpiCgadx3TrMvrKMv8LVTn9mR7LrcSJlmzugFrN%2FOcKTyp0wgkHnqG%2Fu%2BquQwkhCrZjWsdDgTE7X4Kf2FUN3XP%2Buk4uUNowwOk%2BboxdHgsFeL753OGsTh3DDaIWyyNVh06dr9BVZSOKwvVQ9m%2FekySVJc4c89%2F2KJGGjWwTmTnhgTTf2Srv6xQCdIVrzJQLDTLYdPEGzYtgPdzcmFtFj7hr10K8fhaY3ESWX8We21%2BRwiwrhCsMIewmDyyO7aNS%2BRdPtCxkwWAkqEqdB0XL9HIINijbbkNkQ3W%2BUfYPjjcr1pbl6a27I5fqOMR%2BR5KQWXjo97%2FInC7eL3aEm0ND%2FTCpc2%2F4BB92dB61ejENpwSzqiphwoJiC0ZgjfHJWEfBaiQcFd%2BgpDVnkU56xjZxkaIQ5pSdvf%2F35lZyjAo%2BK6oOKvXOx7qnforooHSI4tfsyOUC7gWQptZnsu6HEhKOv3FBCxo4NAkYhrFhe7IYPjYlA6oD5hVCRSvlbXB8a%2FxHHic9mve183gYcljYzLlgnOTN77b1F%2B9VEjo3C%2Fnmez9EZLaQOL9aB0HZ3hnLpNw5XLSzp7Xx%2FROuOpP8OoY0lZz4YALpCHBqNHMEW9RDyRexkpM8JrG3VE6RkJMPxUXiQwRWQh2333PFfLLbSN9qOK5%2BaIiqemwfI0utnpLGkuAK5bwitKbhpcoaJEEdmpdXki6ax5%2FC8b09WjhifrLMJXk%2B7sZqH12IaHPnaLqFO0ySlU3hdoY5CrsD6jQnvzBw%2Be2W5tAR5hun1WNUCCZTSkyRYrDgCPhNloWPcYKztzQ4AyuZQlg4ki7YDmfYPZ16w%2B%2B5lF28suH77PeE8R25SmgVbwOykWoAr3oVBMpuGzCaO3GqlgdgOjUR1IsNBFuWwAJJMlrKOz9dHkeMFsXbN54Z%2FsJWr4LMWodZTStkfIApuBmMGj%2FRVxJEVqzP98h%2BFO2BIB2%2FEnPRgBBaE9YQRbD2wxehuhxPzCzlQJDUmI4k5EfUaGYhfTKk0Zizu1QNoKGbNraa%2FRswmmkGOHMLFZyWNlwv2TNU1Hm9JQ%2BKSx0E20eJczAY8KkuugM37%2FeU6eUAYhwMbaDl4P%2Fxl06VCYrQPAW58H8jrW4NRPyHdUdsOEUBuKpx7CL1bBsauhkJ5RPSF9M0%2FUh4gVjhlsGbc2SoIvtDjgcTV%2F%2FWZS7lKXO26xrzMVU90YGblLM7g0%2BLAPxpAQZR5J15yQKw8re0TWFzQkFWGX2XbkafqfoZmXJcTtC7GhUStCzAi5UD1VVMrgQPjmkZZlrHObTufumOpfd99eAjANqpN5bzkd2n%2FXE4q4ZvdaRen2gMA%3D%3D&__VIEWSTATEGENERATOR=B899CC19&__VIEWSTATEENCRYPTED=&__EVENTVALIDATION=ueSMAy4RTT5P8aLrIWx1hgOwoH1iZrDM1asEe%2BtF7mA%2BSIW8aJdnR%2BXSKq9gx1zoATrz6RC30dQBsEvKCQGnVF%2BVP8kE5gzPpleA9iGCaOWVolpvXGdtLaAknlZ3DJADZnUmWZy1UQbxjvYN41Eu5qG0R9UaZ4IWjvXvzyM6BcHepm1ASIiOYwRd3MFX3jl4lnOUKfQSVT1Yf%2FvErdNBG0R1fQJPL0Guw%2F%2BCtSNWjIjeFutyaL5a0SwlsycoRVChmpJ8X9wbcGAxbKjx9nG%2Fxy9D%2BjKhHffyp%2FdHe6i%2Fs5oCDM9jOo%2BH5xTZ1r%2BSXFA1ZoTpn6c%2B6YzPiPe3XEXm8oTQgBRYAijMFdFe2XVBWXguwQytKlFk9vkyh%2FMYrExyBrxcqQyX3XI0g1yL9Bk4tMB24ffFTffcWLdNCnPx5FSy6Ejx%2FczbboYfpn0yQueR9Rz7a7VutkAYqdqWl6zKzyPlq2647xK5uxCbMfIFzaaijBfcVHnOZEEURtOB%2BQbX8SQhgavMdstw6gQ9aQNmHAm7PNRfJ5LEiJ3dKjaR5T178seK0b1JZkSbyp7EuWXpwntMziEKjEdjf2pUid6YYt4iItrVw05dBJ1Dah81pj1d9CPkLHpsgsIZKLOpw%2F4mvb852GbIDFuJPFyASAphzCWimpvcSgOS%2F%2BNWwxvNfbuEKy8nwEy6SyisDedy8UX8WRYdYJxBM2mf9tBhV3Z25A0rj3jvRRX3gv8SnZYaqXsYWrHeoX8xMdmM27zLbNQ6S51iasVQPlbYEb5lFfbSC7dlSqmYSmXSwwIggGZPc0cg3a41Q8PFLJLpOL13d0hc2AS7IKXYEAiPrFYzcAXq5WoJgCdJsgjSRkVHUGjEbz8oLi6BopPy79T8gSXcwgHGH%2FIbTjw7frshe2o5ZUg2VDzjmcgkXWkbizrxVZCfOf4OZP%2Bo%2Fz%2BpLa%2B%2FLdj1xj3i8c%2BH%2BiCopQAknV0tdXmsAqIbOEXOlW4KzuAYnpSyTFUOzudxp%2F7JB0DlRxLO%2FaEl3cWerV3T%2BntEkpnN6LW15m63lMglK08SrE2LuLvxQE%2FGZJWf4trUpPK1ne5Jik8%2FGzJZTpY1RWOoMDdMGTQCBNdLHJnG8ZF8UZYmueleMx62PyvandTBryI4F%2BZ8050qnbFLF6ZZQYBwqfk3gofVuKdexnFyjQVbgKNyzEtLloeJzKQY93yh3DL%2Bo7yZMXAi5ybnxzeYyP%2F2HKCi8sNFVcScszXv86uXDcKDBfzDxyU%3D&ctl00%24ContentPlaceHolder1%24ddlEmployees=$user_name&ctl00%24ContentPlaceHolder1%24txbFrom=$first_day_of_month&ctl00%24ContentPlaceHolder1%24txbTo=$last_day_of_month&ctl00%24ContentPlaceHolder1%24txbEffortDate=$current_date&ctl00%24ContentPlaceHolder1%24ddlEffortType=0&ctl00%24ContentPlaceHolder1%24txbEffortInHours=$working_hour_amongst_projects&ctl00%24ContentPlaceHolder1%24rbWageType=0&ctl00%24ContentPlaceHolder1%24ddlProjects=$project_number&ctl00%24ContentPlaceHolder1%24ddlPlatforms=$platform&ctl00%24ContentPlaceHolder1%24txbName=${detail:0:254}"

    curl -s -c $cookie_file 'https://dyno.4dsoft.hu/login.aspx' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
    -H 'Accept-Language: en-US,en;q=0.9,hu;q=0.8' \
    -H 'Cache-Control: max-age=0' \
    -H 'Connection: keep-alive' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'DNT: 1' \
    -H 'Origin: https://dyno.4dsoft.hu' \
    -H 'Referer: https://dyno.4dsoft.hu/login.aspx' \
    -H 'Sec-Fetch-Dest: document' \
    -H 'Sec-Fetch-Mode: navigate' \
    -H 'Sec-Fetch-Site: same-origin' \
    -H 'Sec-Fetch-User: ?1' \
    -H 'Upgrade-Insecure-Requests: 1' \
    -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36 Edg/118.0.2088.76' \
    -H 'sec-ch-ua: "Chromium";v="118", "Microsoft Edge";v="118", "Not=A?Brand";v="99"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "Linux"' \
    --data-raw $login_data \
    --compressed > /dev/null

    curl -s -b $cookie_file -c $cookie_file 'https://dyno.4dsoft.hu/Login.aspx' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
    -H 'Accept-Language: en-US,en;q=0.9,hu;q=0.8' \
    -H 'Cache-Control: max-age=0' \
    -H 'Connection: keep-alive' \
    -H 'DNT: 1' \
    -H 'Referer: https://dyno.4dsoft.hu/login.aspx' \
    -H 'Sec-Fetch-Dest: document' \
    -H 'Sec-Fetch-Mode: navigate' \
    -H 'Sec-Fetch-Site: same-origin' \
    -H 'Sec-Fetch-User: ?1' \
    -H 'Upgrade-Insecure-Requests: 1' \
    -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36 Edg/118.0.2088.76' \
    -H 'sec-ch-ua: "Chromium";v="118", "Microsoft Edge";v="118", "Not=A?Brand";v="99"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "Linux"' \
    --compressed > /dev/null

    curl -s -b $cookie_file 'https://dyno.4dsoft.hu/Munkavegzes.aspx' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
    -H 'Accept-Language: en-US,en;q=0.9,hu;q=0.8' \
    -H 'Cache-Control: max-age=0' \
    -H 'Connection: keep-alive' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'DNT: 1' \
    -H 'Origin: https://dyno.4dsoft.hu' \
    -H 'Referer: https://dyno.4dsoft.hu/Munkavegzes.aspx' \
    -H 'Sec-Fetch-Dest: document' \
    -H 'Sec-Fetch-Mode: navigate' \
    -H 'Sec-Fetch-Site: same-origin' \
    -H 'Sec-Fetch-User: ?1' \
    -H 'Upgrade-Insecure-Requests: 1' \
    -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36 Edg/118.0.2088.76' \
    -H 'sec-ch-ua: "Chromium";v="118", "Microsoft Edge";v="118", "Not=A?Brand";v="99"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "Linux"' \
    --data-raw $report_data \
    --compressed > /dev/null
}

if [ $numprojects -ne 0 ]; then
    working_hour_amongst_projects=$(echo "scale=2; $working_hour_amongst_projects / $numprojects" | bc)
    for commit_log_file in $commit_log_dir/*; do
        log_to_dyno
    done
else
    log_to_dyno
fi

rm $cookie_file
rm $commit_log_dir/*

notify-send "Dyno report" "Dyno report for today has been finised"

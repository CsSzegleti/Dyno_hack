#!/bin/bash

current_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd $current_path

cookie_file="cookies.txt"
credentials_file="credentials.txt"

user_name=$(awk '{print $1}' "$credentials_file")
password=$(awk '{print $2}' "$credentials_file")

login_data="__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=1cQ6PRKMBnxwKT%2BKCykC6AcfZnIv1WhrzCa2OjxHo51GYuVOsRDYQOLup2lCylVQG2rxs7Lmg5ykSK6Obl4hbXlUbM4QNTjIB9eq5DYJrIROf2rPPm%2Fe7s9RySkXcb0P2H%2BEn4A%2Fj97qB5sfLtXDhYP4uiWQKvRiYO25UF1%2BZV%2BMsnkxZ7Pe3jrWtBLCXm%2BRqzC%2F5o3zUv1frnJd0E8TfnbN%2FuWRBQBrefbEu%2BAsyhGSClrcGYEmd%2FTFOxUwm5lq6P2Ojq7cH6xZqIX14nhsWg%3D%3D&__VIEWSTATEGENERATOR=C2EE9ABB&__EVENTVALIDATION=SdHh%2BH%2FDoUNX5kVUw%2BsmjNOy%2BJYQwjK0ov4C14aoN5Eg7KjT1p2Jk1YfQ1S40OuOtFQlf%2FfZCvVYCuHW1CnXgR1lYt1kiEwyRnnZE5p53AQYfNsmiAZ%2BnO6LNxQWfw9jJNU18KzKv8wQpsJQe6Yjar%2B5IE5RXSjzhln8qzmDnsH%2BoveCUDRaU%2BeRdquynYlF%2BVIVkKx9KKFJX1wO1L7kfQ%3D%3D&ctl00%24ContentPlaceHolder1%24LoginView1%24Login1%24UserName=$user_name&ctl00%24ContentPlaceHolder1%24LoginView1%24Login1%24Password=$password&ctl00%24ContentPlaceHolder1%24LoginView1%24Login1%24LoginButton=Bejelentkez%C3%A9s"

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
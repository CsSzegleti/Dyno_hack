#!/bin/bash

# String to URL-encode
string_to_encode="This is a sample string with spaces & special characters like % and +"

# Use printf to URL-encode the string
url_encoded_string=$(printf "%s" "$string_to_encode" | jq -s -R -r @uri)

# Print the URL-encoded string
echo "URL-encoded string: $url_encoded_string"
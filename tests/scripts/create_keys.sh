#!/bin/bash

set -euo pipefail

CLOUDTKEFILES=$1

#Function to generate admin key
generate() {
    local tke_files_path=$1

    resultDir="$tke_files_path/CLOUDTKEFILES"

    #Check if directory exists or not
    if [ ! -d "$resultDir" ]; then
        mkdir -p "$resultDir" >&2
        echo "Directory '$resultDir' created." >&2
    else
        rm -rf "$resultDir" >&2
        mkdir -p "$resultDir" >&2
        echo "Directory '$resultDir' created." >&2
    fi
    #Set the environment variable CLOUDTKEFILES on your workstation to specify the directory where you want to save signature key file.
    export CLOUDTKEFILES=$resultDir

    #Random generated password for signature key
    token="$(openssl rand -base64 16)" >&2

    #Generate the signature key
    /usr/bin/expect <<EOF
    log_user 0
    spawn ibmcloud tke sigkey-add
    expect "Enter an administrator name to be associated with the signature key:"

    send "admin\r"

    expect {
    "Enter a password to protect the signature key:" {send $token\r; exp_continue}
    "Re-enter the password to confirm:" {send $token\r}
    }
    expect
EOF

    #Return json output
    jq -n -r --arg name "admin" --arg token "$token" --arg key "$resultDir/1.sigkey" '{"name":$name,"key":$key,"token":$token}'
}

handle_error() {
    echo '{"name": "NOT-FOUND","key": "NOT-FOUND","token": "NOT-FOUND"}'
    exit 0
}

generate="$(generate "$CLOUDTKEFILES")"

jq -n -r --arg result "$generate" '$result'

URL=$2
USERNAME=kahono0
PASS=$(pat.sh)

ACTION=$1
gen_url(){
    NEW_URL=$(echo $URL | sed 's/https:\/\///g')
    URL=https://$USERNAME:$PASS@$NEW_URL
    echo $URL
}

echo "Url is $(gen_url)"

if [[ -z $URL ]]; then
    echo "URL is empty"
    exit 1
elif [[ $ACTION == "clone" ]]; then
    git clone $(gen_url)
elif [[ $ACTION == "set" ]]; then
    git remote set-url origin $(gen_url)
elif [[ $ACTION == "add" ]]; then
    git remote add origin $(gen_url)
else
    gen_url
    exit 1
fi

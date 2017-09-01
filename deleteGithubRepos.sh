#!/bin/bash -e

RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

token=<Your access token with delete_repo scope>
user=<Your username/orgName>
isOrg=true #can be set to true/false

#TODO: Add pagination
getReposUrl="https://api.github.com/users/$user/repos?per_page=100"

if [[ "$isOrg" == "true" ]]; then
  getReposUrl="https://api.github.com/orgs/$user/repos?per_page=100"
fi

curl -H "Authorization: token $token" $getReposUrl > repos.json

for name in $(cat repos.json | jq -r '.[] | .name')
do
  echo -e "${RED}Do you want to delete $user/$name?${NC}"
  read input
  if [[ "$input" == "Y" ]] || [[ "$input" == "Yes" ]] || [[ "$input" == "YES" ]]; then
    echo "Deleting $user/$name"
    curl -XDELETE -H "Authorization: token $token" "https://api.github.com/repos/$user/$name"
    echo -e "${GREEN}Deleted $user/$name${NC}"
  else
    echo "Skipping $user/$name"
  fi
done

rm repos.json
#/bin/bash

set -e -o pipefail

mypassword=$1

if [ "$#" -ne 1 ]; then
	read -s -p "Password for JIRA:" mypassword
fi

SUFF='@oicr.on.ca'
ROOT='https://jira.oicr.on.ca/rest/api/2/search'


declare -a names=("mtaschuk" "pruzanov" "mlaszloffy" "tbeck" "xluo" 'michael.moorhouse@oicr.on.ca' "tdebat" "ysundaravadanam" "lheisler" "dyuen" "fqureshi");

CMD="Rscript parseJIRAJSON.R TicketsClosedLast30days";
for n in "${names[@]}"
do
	curl -u mtaschuk:${mypassword} -k "$ROOT?maxResults=1000&jql=assignee=\"${n}\"+AND+resolved>=-30d" > ${n%$SUFF}-30
	CMD="${CMD} ${n%$SUFF}-30";
done

echo $CMD;
eval $CMD;

for n in "${names[@]}"
do
	rm ${n%$SUFF}*
done

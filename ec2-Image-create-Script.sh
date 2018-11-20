#!/bin/bash

#
# @Purpose              Creates an image (AMI) of the given EC2 instance
# @Background   Meant to be run as a cronjob. Requires that awscli is installed. Assumes that the 
# instance running this command has the permission ec2:CreateImage assigned via IAM.
#
# @Usage:               ec2-create-image <instance-id>
#

DATE=$(date +%Y-%m-%d_%H-%M)
AMI_NAME="Blum-prod-server-$DATE"
AMI_DESCRIPTION="Blum-prod-server-$DATE"
INSTANCE_ID=$1

printf "Requesting AMI for instance $1...\n"

aws ec2 create-image --instance-id $1 --name "$AMI_NAME" --description "$AMI_DESCRIPTION" --no-reboot > Ami-Id.log

if [ $? = 0 ];
then
    echo "The Image has been created of the $1 with the help of script" > BODY.txt

    cat BODY.txt | mail -s "Image creation $AMI_NAME($1)" hitendra.katara@galaxyweblinks.in,satyam@galaxyweblinks.in

else
    echo "The Image has not been created, sometime is wrong with the script or with the instance" > BODY.txt

    cat BODY.txt | mail -s "Image creation $AMI_NAME($1)" hitendra.katara@galaxyweblinks.in,satyam@galaxyweblinks.in
fi
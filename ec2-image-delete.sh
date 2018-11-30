#/bin/bash

# This script is created to delete the created image of the ec2 instance

# It is the extract the Ami-Id from log file and used that image id to delete the image

# Step1:- Its describe the image first then deregistred the image 

# Step2:- After  the deregistred  it delete the snap shot of the volume

echo "The previous image start delete from here"

# greping the image ID from the log filr

ami=$( grep -o 'ami[^"]*' Ami-Id.log)

# Now the is described using the extracted image id

aws ec2 describe-images --image-ids "$ami" > imagedescription.log

# Now it is checking Image is properly created, that we created using the previous script

State=$(grep -o 'available[^"]*' imagedescription.log)

# If the latest image is create correctly then it delete the previous image

if [ State = available ];
 then
    echo "Deletion of previous image has been stated"
    ami2=$( grep -o 'ami[^"]*' Delete-Id.log)
    aws ec2 describe-images --image-ids "$ami2" > imagedescription2.log
    snap=$(grep -o 'snap[^"]*' imagedescription2.log)
    aws ec2 deregister-image --image-id "$ami2"
    aws ec2 delete-snapshot --snapshot-id "$snap"
    cp -pv Ami-Id.log Delete-Id.log    # it is copying the latest image id to the delete log file
    printf "AMI request complete!\n"
    echo "The latest image is created correctly and  the previous image $ami2 has been deleted " > Body2.txt
    cat Body2.txt | mail -s "Image Deletion $ami2" Mail/id/to/which/you/want/send/mail
else
    echo "The latest image is not been created correctly that why's the previous image has also not being deleted" > Body2.txt
    cat Body2.txt | mail -s "Image Deletion $ami2" Mail/id/to/which/you/want/send/mail
fi
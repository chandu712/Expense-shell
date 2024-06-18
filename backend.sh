#!/bin/bash

USERID=$(id -u)
# Generating lofiles
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

# colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "Please enter DB password: "
read mysql_root_password

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access"
    exit 1 #Manually exit if error occurs
else
    echo "You are a super user" 
fi


VALIDATE(){

    if [ $1 -ne 0 ]
    then
        echo -e "$2 ..... $R FAILURE $N"
        exit 1 # Manually exit if error occurs
    else
        echo -e "$2 ..... $G SUCCESS $N"
    fi
}


dnf module disable nodejs -y &>>LOGFILE
VALIDATE $? "Disabling default nodejs" 

dnf module enable nodejs:20 -y &>>LOGFILE
VALIDATE $? "Enabling default nodejs"

dnf install nodejs -y &>>LOGFILE
VALIDATE $? "Disabling default nodejs" 


id expense &>>LOGFILE
if [ $? -ne 0 ]
then
    useradd expense &>>LOGFILE
    VALIDATE $? "Creating expense user" 
else
    echo -e "Expense user is already created ....$Y SKIPPING $N"
    exit 1
fi

# if app directory is not created it will create one. This command is idempotenet
mkdir -p /app
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "Downloading the backend code"

cd /app
unzip /tmp/backend.zip
VALIDATE $? "Extracted backend code"

npm install
VALIDATE $? "Installing NodeJS dependencies"

# Humans can use vim editor, shell script doesn't understand vim
#vim os for visual.
# Create a backend.service file in the same Expense project folder, copy the source file(give absolute path) to 
# destination folder(/etc/systemd/service)
# Absolute path of backend.service is /home/ec2-user/Expense-shell/backend.service



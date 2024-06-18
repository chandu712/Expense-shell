#!/bin/bash

USERID=$(id -u)

# Generating lofiles
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

# colors
R="\e31m"
G="\e32m"
Y="\e33m"
N="\e0m"

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

# Install MySQL Server 
dnf install mysql-server -y &>>LOGFILE
VALIDATE $? "Installation of MYSQL Server"

systemctl enable mysqld  &>>LOGFILE
VALIDATE $? "Enabling mysql server"

systemctl start mysqld  &>>LOGFILE
VALIDATE $? "Starting mysql server"

mysql_secure_installation --set-root-pass ExpenseApp@1  &>>LOGFILE
VALIDATE $? "Setting up root password"








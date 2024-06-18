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
read -s mysql_root_password
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

# mysql_secure_installation --set-root-pass ExpenseApp@1  &>>LOGFILE
# VALIDATE $? "Setting up root password"

#Above lines of code are not idempotenet in nature.So, we need to do some changes to achieve idempotency nature.



mysql -h db.chandudevops.online -uroot -p${mysql_root_password}  -e 'SHOW DATABASES;" &>>$LOGFILE

if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE

    # Here we are hardcoding the password in code, it is not a good practice. Instead we can pass values during runtime by using read command
    VALIDATE $? "MYsql root password setup".
    # We need to enter correct password. otherwise backend(Nodejs) will fail, because the same password has setup for the backend
else
    echo -e "MYSQL Root password is already setup .... $Y SKIPPING $N"
    exit 1
fi








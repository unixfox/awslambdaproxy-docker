#!/bin/ash

mkdir /tmp/etc
mkdir /tmp/etc/ssh
ssh-keygen -A -f /tmp
/usr/sbin/sshd
if [[ -f /run/secrets/AWS_ACCESS_KEY_ID && -f /run/secrets/AWS_SECRET_ACCESS_KEY ]];
then
    export AWS_ACCESS_KEY_ID=$(cat /run/secrets/AWS_ACCESS_KEY_ID)
    export AWS_SECRET_ACCESS_KEY=$(cat /run/secrets/AWS_SECRET_ACCESS_KEY)
fi
/app/awslambdaproxy setup
/app/awslambdaproxy run -r ${AWS_REGIONS} --ssh-port ${SSH_PORT} -l ${PROXY_LISTENERS} -f ${PROXY_FREQUENCY_REFRESH} -m ${AWS_LAMBDA_MEMORY}
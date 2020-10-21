#!/bin/bash

#RHEL subscription credentials pulled from environment variables
rhel_subscription_user=$RHEL_SUBSCRIPTION_USER
rhel_subscription_pwd=$RHEL_SUBSCRIPTION_PWD

#checking if environment variables were set

if [[ ! -v rhel_subscription_user ]]; then
    echo "RHEL subscription user is not set and it is required." 1>&2
    exit 1
elif [[ ! -v rhel_subscription_pwd ]]; then
    echo "RHEL subscription password is not set and it is required." 1>&2
    exit 1
fi
#REHL subscription manager registration

subscription-manager register --username $rhel_subscription_user --password $rhel_subscription_pwd --auto-attach

#patching the operating system
yum -y upgrade
yum -y update
yum -y clean all

#installing the operating system
yum install -y openscap openscap-utils scap-security-guide

#Running openscap profile :
#Title: CIS Red Hat Enterprise Linux 7 Benchmark
#Id: xccdf_org.ssgproject.content_profile_cis
echo "Before running open scap"
oscap xccdf eval --remediate --profile xccdf_org.ssgproject.content_profile_cis --fetch-remote-resources /usr/share/xml/scap/ssg/content/ssg-rhel7-ds.xml
echo "After running open scap"
#Cleaning up openscap
echo "Before cleaning up"
yum -y autoremove openscap openscap-utils scap-security-guide

yum -y clean all

#cleaning up environment variables
unset rhel_subscription_user
unset rhel_subscription_pwd

subscription-manager unregister
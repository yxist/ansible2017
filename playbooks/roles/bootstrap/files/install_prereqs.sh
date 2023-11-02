#!/bin/bash
# install ansible prereqs manually or all apt-based ansible commands will fail
# i know its kinda ugly but it works

#./install_prereqs.sh

APT_PACKAGES="python python-apt python-pycurl sshpass"
YUM_PACKAGES="python python-pycurl sshpass"
DNF_PACKAGES="python python-dnf python-pycurl sshpass libselinux-python"

if [ -x "$(command -v dnf)" ]; then
	PACKAGES=$DNF_PACKAGES
	PACKAGE_COUNT=$(echo "$PACKAGES"| wc -w)
	INSTALLED_PACKAGE_COUNT=$(expr `dnf -q list installed $PACKAGES | wc -l` - 1)
	if [ $INSTALLED_PACKAGE_COUNT -ne $PACKAGE_COUNT ]; then
		dnf install -y $PACKAGES

		if [ $? -eq 0 ]; then
			echo "ANSIBLE_CHANGE"
		else
			echo "ANSIBLE_FAIL"
		fi
	fi

elif [ -x "$(command -v apt)" ]; then
	PACKAGES=$APT_PACKAGES
	PACKAGE_COUNT=$(echo "$PACKAGES"| wc -w)
	INSTALLED_PACKAGE_COUNT=`dpkg-query -W -f='${Status}\n' $PACKAGES | grep "install ok installed" | wc -l `
	if [ $INSTALLED_PACKAGE_COUNT -ne $PACKAGE_COUNT ]; then 
		apt-get update
		apt-get install -y $PACKAGES

		if [ $? -eq 0 ]; then
			echo "ANSIBLE_CHANGE" 
		else
			echo "ANSIBLE_FAIL"
		fi

	fi

elif [ -x "$(command -v yum)" ]; then
	PACKAGES=$YUM_PACKAGES
	PACKAGE_COUNT=$(echo "$PACKAGES"| wc -w)
	INSTALLED_PACKAGE_COUNT=$(expr `yum -q list installed $PACKAGES | wc -l` - 1)
	if [ $INSTALLED_PACKAGE_COUNT -ne $PACKAGE_COUNT ]; then
		yum install -y $PACKAGES

		if [ $? -eq 0 ]; then
			echo "ANSIBLE_CHANGE"
		else
			echo "ANSIBLE_FAIL"
		fi
	fi
else
	echo "apt nor yum nor dnf found"
	echo "ANSIBLE_FAIL"
fi

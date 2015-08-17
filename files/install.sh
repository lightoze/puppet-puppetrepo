#!/bin/bash

. /etc/os-release

PUPPET=1.2

if [[ $ID == centos || $ID == rhel ]]; then
    rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-${VERSION_ID}.noarch.rpm
    yum install -y "puppet-agent-$PUPPET.*"
elif [[ $ID == debian || $ID == ubuntu ]]; then
    wget -O /tmp/puppet-release.deb https://apt.puppetlabs.com/puppetlabs-release-pc1-$(lsb_release -cs).deb
    dpkg -i /tmp/puppet-release.deb
    apt-get update
    apt-get install -y "puppet-agent=$PUPPET.*"
else
    echo "Unsupported OS $PRETTY_NAME"
    exit 1
fi

puppet agent --enable
echo "Type Puppet server name, followed by [ENTER]:"
read server
puppet agent --test --waitforcert 60 --server ${server}

# puppetrepo

## Overview

This module manages Puppet agent repository and package version locking.
It works on Debian and RedHat `$osfamily`.

### What puppetrepo affects

* On systems using Yum, it will install yum-plugin-versionlock and add allowed agent
  package version to `/etc/yum/pluginconf.d/versionlock.list` file.
* On systems using Apt, it will pin agent package version to specified pattern.

## Usage

Just include `puppetrepo` class. It has a single parameter `puppet_agent_version`,
which is a pattern for required `puppet-agent` package version (e.g. `1.4.*`).

## Reference

There is an additional resource `puppetrepo::install_script`, which creates a Puppet
installation bash script to bootstrap new nodes. You can create in on Puppet master and
serve over HTTP, and then run it like `curl https://puppet.internal/install.sh | sudo bash`
on fresh node installs.

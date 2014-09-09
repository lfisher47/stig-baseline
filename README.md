#Puppet module wrapper to install puppet and run baseline
=============

This module is used to install the DISA stig rules on a box using masterless puppet.  The kickstart included is set up to run in my lab, so the centos mirror url would need to change for you to run locally.

This project uses Librarian Puppet <http://librarian-puppet.com/> to download module dependencies.

The ks.cfg file cannot be run directly from github due to line ending issues.

#Running of kickstart to use module

This process assumes you have access to the internet

* Download http://mirror.chpc.utah.edu/pub/centos/6.5/isos/x86_64/CentOS-6.5-x86_64-netinstall.iso
* Boot server from iso, edit boot parameters to include ks=http://location/of/kickstart/ks.cfg
* Wait for completion

# How to run without internet access or after system is built

* Build system as current processes dictat
* Install puppet version 3.0 or later
* Copy contents of the git repo to /etc/puppet/puppetconfigs
* Copy the /etc/puppet/puppetconfigs/modules directory from a system that does have access to the internet.
* puppet apply -v /etc/puppet/puppetconfigs/manifests/site.pp --modulepath /etc/puppet/puppetconfigs/modules/

# STIG Rules not addressed

All loghost rules were not addressed as these are network specific.  

Since we are using saz/rsyslog, you just need to add the loghost info in the class definition in site.pp.
An example of this would be 
```
class { 'rsyslog::client':
    log_remote  => true,
    log_local   => true,
    server      => 'server.domain.com',
    remote_type => 'tcp',
  }
```

Firewall rules are in place, but due to the nature of kickstart and iptables, you need to run puppet after the first reboot to get the firewall rules to be applied.  This means running `puppet apply -v /etc/puppet/puppetconfigs/manifests/site.pp --modulepath /etc/puppet/puppetconfigs/modules/`

NTP configurations are by default set to go to the internet.  If you want to change the servers for ntp, you should have the following config.
```
class { 'ntp':
  servers => [ 'server1.corp.com','server2.corp.com' ],
}
```

Running the automated SCAP scan version 4 available on the DISA website, this configuration received a 91% compliance.


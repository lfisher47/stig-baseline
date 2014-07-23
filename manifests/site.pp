node default {

  #V-38487 - gpgcheck=1 set on all extra repos being added.
  class { 'yum':
    clean_repos => true,
    extrarepo   => ['epel', 'puppetlabs','vmware_tools'],
  } 
  class { 'auditd': }
  class { 'aide': }
  class { 'accounts': }

}

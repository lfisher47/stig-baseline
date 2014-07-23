node default {

  class { 'yum':
    clean_repos => true,
    extrarepo   => ['epel', 'puppetlabs','vmware_tools'],
  } 

}

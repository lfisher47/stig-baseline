node default {

  #RHEL-06-000145, RHEL-06-000148, RHEL-06-000154, RHEL-06-000159
  class { 'auditd': }
  class { 'aide': }
  class { 'accounts': }
  class { 'stig_sysctl': }
  class { 'grub': }
  # RHEL-06-000020, RHEL-06-000023
  class { 'selinux':
    mode => 'enforcing',
    type => 'targeted',
  }
  #RHEL-06-000133, RHEL-06-000134, RHEL-06-000135,
  class { 'rsyslog::client':
    log_remote => false,
    log_local  => true,
  }
  class { 'ssh':
    server_options => { 
      #RHEL-06-000227
      'Protocol' => '2',
      #RHEL-06-000230
      'ClientAliveInterval' => '900',
      #RHEL-06-000231
      'ClientAliveCountMax' => '0',
      #RHEL-06-000234
      'IgnoreRhosts' => 'yes',
      #RHEL-06-000236
      'HostbasedAuthentication' => 'no',
      #RHEL-06-000237
      'PermitRootLogin' => 'no',
      #RHEL-06-000239
      'PermitEmptyPasswords' => 'no',
      #RHEL-06-000240
      'Banner' => '/etc/issue',
      #RHEL-06-000241
      'PermitUserEnvironment' => 'no',
      #RHEL-06-000243
      'Ciphers' => 'aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc',
      #RHEL-06-000507
      'PrintLastLog' => 'yes',
    }
  }
  class { 'inittab':
    #RHEL-06-000290
    default_runlevel  => '3',
    #RHEL-06-000286
    enable_ctrlaltdel => false,
    #RHEL-06-000069
    require_single_user_mode_password => true,
  }
  #RHEL-06-000113, RHEL-06-000116, RHEL-06-000117
  class { 'firewall': }

  #RHEL-06-000247, RHEL-06-000248 
  class { 'ntp': }

  class { 'stig_generic': }
  class { 'kernel': }
  class { 'pam': }

}

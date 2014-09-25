node default {

  #RHEL-06-000145, RHEL-06-000148, RHEL-06-000154, RHEL-06-000159
  class { 'auditd': }
  class { 'accounts': }
  class { 'stig_sysctl': 
    ip_forward   => 0,
    log_martians => 1,
  }
  class { 'grub': }
  # RHEL-06-000020, RHEL-06-000023
  class { 'selinux':
    mode        => 'enforcing',
    installmake => false,
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
      #RHEL-06-000241
      'PermitUserEnvironment' => 'no',
      #RHEL-06-000243
      'Ciphers' => 'aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc',
      #RHEL-06-000507
      'PrintLastLog' => 'yes',
      'X11Forwarding' => 'no',
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
  class { 'rhel::firewall': 
    ipv6 => false,
  }
  class { 'firewall_wrapper': }
  class { 'logrotate_wrapper': }

  #RHEL-06-000247, RHEL-06-000248 
  class { 'ntp': }

  class { 'stig_generic': }
  class { 'kernel': }
  class { 'pam': }

  #Ensure sudo is installed, configured and allows the wheel group.
  class { 'sudo': }
  class { 'sudo::allow': 
    add_groups => 'wheel',
  }
  class { 'aide': 
    aide_rules => {
      'ALLXTRAHASHES' => { 'rules' => 'sha1+rmd160+sha256+sha512+tiger' },
      'EVERYTHING'    => { 'rules' => 'R+ALLXTRAHASHES' },
      'NORMAL'        => { 'rules' => 'R+rmd160+sha256' },
      'DIR'           => { 'rules' => 'p+i+n+u+g+acl+selinux+xattrs' },
      'PERMS'         => { 'rules' => 'p+i+u+g+acl+selinux' },
      'LOG'           => { 'rules' => '>' },
      'LSPP'          => { 'rules' => 'R+sha256' },
      'DATAONLY'      => { 'rules' => 'p+n+u+g+s+acl+selinux+xattrs+md5+sha256+rmd160+tiger' },
    },
    aide_watch => {
      '/boot'                    => { 'rules' => 'NORMAL' },
      '/bin'                     => { 'rules' => 'NORMAL' },
      '/sbin'                    => { 'rules' => 'NORMAL' },
      '/lib'                     => { 'rules' => 'NORMAL' },
      '/lib64'                   => { 'rules' => 'NORMAL' },
      '/opt'                     => { 'rules' => 'NORMAL' },
      '/usr'                     => { 'rules' => 'NORMAL' },
      '/root'                    => { 'rules' => 'NORMAL' },
      '/usr/src'                 => { 'type'  => 'exclude' },
      '/usr/tmp'                 => { 'type'  => 'exclude' },
      '/etc'                     => { 'rules' => 'PERMS' },
      '/etc/mtab'                => { 'type'  => 'exclude' },
      '/etc/exports'             => { 'rules' => 'NORMAL' },
      '/etc/fstab'               => { 'rules' => 'NORMAL' },
      '/etc/passwd'              => { 'rules' => 'NORMAL' },
      '/etc/group'               => { 'rules' => 'NORMAL' },
      '/etc/gshadow'             => { 'rules' => 'NORMAL' },
      '/etc/shadow'              => { 'rules' => 'NORMAL' },
      '/etc/security/opasswd'    => { 'rules' => 'NORMAL' },
      '/etc/hosts.allow'         => { 'rules' => 'NORMAL' },
      '/etc/hosts.deny'          => { 'rules' => 'NORMAL' },
      '/etc/sudoers'             => { 'rules' => 'NORMAL' },
      '/etc/skel'                => { 'rules' => 'NORMAL' },
      '/etc/logrotate.d'         => { 'rules' => 'NORMAL' },
      '/etc/resolv.conf'         => { 'rules' => 'DATAONLY' },
      '/etc/nscd.conf'           => { 'rules' => 'NORMAL' },
      '/etc/securetty'           => { 'rules' => 'LSPP' },
      '/etc/profile'             => { 'rules' => 'NORMAL' },
      '/etc/bashrc'              => { 'rules' => 'NORMAL' },
      '/etc/bash_completion.d/'  => { 'rules' => 'NORMAL' },
      '/etc/login.defs'          => { 'rules' => 'LSPP' },
      '/etc/zprofile'            => { 'rules' => 'NORMAL' },
      '/etc/zshrc'               => { 'rules' => 'NORMAL' },
      '/etc/zlogin'              => { 'rules' => 'NORMAL' },
      '/etc/zlogout'             => { 'rules' => 'NORMAL' },
      '/etc/profile.d/'          => { 'rules' => 'NORMAL' },
      '/etc/X11/'                => { 'rules' => 'NORMAL' },
      '/etc/named.conf'          => { 'rules' => 'NORMAL' },
      '/etc/named.iscdlv.key'    => { 'rules' => 'NORMAL' },
      '/etc/named.rfc1912.zones' => { 'rules' => 'NORMAL' },
      '/etc/named.root.key'      => { 'rules' => 'NORMAL' },
      '/var/named'               => { 'rules' => 'NORMAL' },
      '/etc/yum.conf'            => { 'rules' => 'NORMAL' },
      '/etc/yumex.conf'          => { 'rules' => 'NORMAL' },
      '/etc/yumex.profiles.conf' => { 'rules' => 'NORMAL' },
      '/etc/yum/'                => { 'rules' => 'NORMAL' },
      '/etc/yum.repos.d/'        => { 'rules' => 'NORMAL' },
      '/etc/puppet'              => { 'type'  => 'exclude' },
      '/var/log'                 => { 'rules' => 'LOG' },
      '/var/log/audit'           => { 'rules' => 'LOG' },
      '/var/run/utmp'            => { 'rules' => 'LOG' },
      '/var/log/sa'              => { 'type'  => 'exclude' },
      '/var/log/aide/aide.log'   => { 'type'  => 'exclude' },
      '/etc/audit/'              => { 'rules' => 'LSPP' },
      '/etc/libaudit.conf'       => { 'rules' => 'LSPP' },
      '/usr/sbin/stunnel'        => { 'rules' => 'LSPP' },
      '/var/spool/at'            => { 'rules' => 'LSPP' },
      '/etc/at.allow'            => { 'rules' => 'LSPP' },
      '/etc/at.deny'             => { 'rules' => 'LSPP' },
      '/etc/cron.allow'          => { 'rules' => 'LSPP' },
      '/etc/cron.deny'           => { 'rules' => 'LSPP' },
      '/etc/cron.d/'             => { 'rules' => 'LSPP' },
      '/etc/cron.daily/'         => { 'rules' => 'LSPP' },
      '/etc/cron.hourly/'        => { 'rules' => 'LSPP' },
      '/etc/cron.monthly/'       => { 'rules' => 'LSPP' },
      '/etc/cron.weekly/'        => { 'rules' => 'LSPP' },
      '/etc/crontab'             => { 'rules' => 'LSPP' },
      '/var/spool/cron/root'     => { 'rules' => 'LSPP' },
      '/var/log/faillog'         => { 'rules' => 'LSPP' },
      '/var/log/lastlog'         => { 'rules' => 'LSPP' },
      '/etc/hosts'               => { 'rules' => 'LSPP' },
      '/etc/sysconfig'           => { 'rules' => 'LSPP' },
      '/etc/inittab'             => { 'rules' => 'LSPP' },
      '/etc/grub/'               => { 'rules' => 'LSPP' },
      '/etc/rc.d'                => { 'rules' => 'LSPP' },
      '/etc/ld.so.conf'          => { 'rules' => 'LSPP' },
      '/etc/localtime'           => { 'rules' => 'LSPP' },
      '/etc/sysctl.conf'         => { 'rules' => 'LSPP' },
      '/etc/modprobe.conf'       => { 'rules' => 'LSPP' },
      '/etc/pam.d'               => { 'rules' => 'LSPP' },
      '/etc/security'            => { 'rules' => 'LSPP' },
      '/etc/aliases'             => { 'rules' => 'LSPP' },
      '/etc/postfix'             => { 'rules' => 'LSPP' },
      '/etc/ssh/sshd_config'     => { 'rules' => 'LSPP' },
      '/etc/ssh/ssh_config'      => { 'rules' => 'LSPP' },
      '/etc/stunnel'             => { 'rules' => 'LSPP' },
      '/etc/vsftpd.ftpusers'     => { 'rules' => 'LSPP' },
      '/etc/vsftpd'              => { 'rules' => 'LSPP' },
      '/etc/issue'               => { 'rules' => 'LSPP' },
      '/etc/issue.net'           => { 'rules' => 'LSPP' },
      '/var/log/and-httpd'       => { 'type'  => 'exclude' },
      '/root/\..*'               => { 'rules' => 'PERMS' },
      '/etc/.*~'                 => { 'type'  => 'exclude' },
    },
  }
}

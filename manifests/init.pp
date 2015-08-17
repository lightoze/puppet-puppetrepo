class puppetrepo($puppet_agent_version = '1.2.*') {
  case $::osfamily {
    default: { fail("Unsupported platform ${::osfamily}") }
    'Debian': {
      apt::pin { 'puppet-agent':
        version  => $puppet_agent_version,
        priority => 1001,
      }
    }
    'RedHat': {
      $script = "${::puppet_vardir}/yum-lock.sh"
      ensure_resource('package', 'yum-utils', { 'ensure' => 'present' })
      ensure_resource('package', 'yum-plugin-versionlock', { 'ensure' => 'present' })
      file { $script:
        mode    => '755',
        content => template('puppetrepo/yum-lock.sh.erb'),
        require => [
          Package['yum-utils'],
          Package['yum-plugin-versionlock'],
        ],
      }
      ~>
      exec { 'puppet-yum-lock':
        command     => $script,
        refreshonly => true,
      }
      cron { 'puppet-yum-lock':
        command => $script,
        ensure  => present,
        hour    => '3',
        minute  => '45',
      }
    }
  }
}

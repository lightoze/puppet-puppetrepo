class puppetrepo($puppet_version = '3.6.*', $facter_version = '2.1.*') {
    case $::osfamily {
        default: { fail("Unsupported platform ${::osfamily}") }
        'Debian': {
            apt::source { 'puppetlabs':
                location => 'http://apt.puppetlabs.com',
                release => "${::lsbdistcodename}",
                repos => 'main dependencies',
                key => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
                key_server => 'pgp.mit.edu',
            }
            apt::hold { ['puppet', 'puppet-common']:
                version => $puppet_version
            }
            apt::hold { 'facter':
                version => $facter_version
            }
        }
        'RedHat': {
            $script = "${::puppet_vardir}/yum-lock.sh"
            package { 'yum-plugin-versionlock':
                ensure => present
            }
            ->
            file { $script:
                mode => 755,
                content => template('puppetrepo/yum-lock.sh.erb'),
            }
            ~>
            exec { 'yum-lock':
                command => $script,
                refreshonly => true,
            }
            cron { 'yum-lock':
                command => $script,
                ensure => present,
                hour => '0',
                minute => '0',
            }
        }
    }
}

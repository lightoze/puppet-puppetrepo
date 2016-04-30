define puppetrepo::install_script(
  $file = $name,
  $puppet_agent_version = $puppetrepo::puppet_agent_version,
  $servername = $::servername,
) {
  file { $file:
    content => template('puppetrepo/install.sh.erb'),
  }
}

# ubuntu-base puppet module
# Based upon:
# dbp.pp - EDV-Beratung&Service Debian Best Practices
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.
#
# Adapted by Alexander Werner <alex@documentfoundation.org>

class ubuntu-base {
  case $lsbdistid {
    'Ubuntu': { }
    default: { fail("\$lsbdistid of ${fqdn} is not 'Ubuntu' but '${lsbdistid}'.") }
  }
  
  #######################################################################
  #######################################################################
  # Basic package selection
  #package {
  #  ["apticron",
  #   "apt-listchanges",
  #   "deborphan",
  #   "screen",
  #   "mmv",
  #   "less",
  #   "bzip2",
  #   "net-tools",
  #   "man-db",
  #   "sudo",
  #   "pwgen",
  #   "reportbug",
  #   "pciutils",
  #   "bash-completion",
  #   "anacron",
  #   "dnsutils",
  #   "procmail",
  #   "iptraf",
  #   "lynx",
  #   "ftp",
  #   "nmap",
  #   "bsd-mailx",
  #   "zip",
  #   "mc",
  #   "telnet",
  #   "patch",
  #   "at",
  #   "lha",
  #   "arj",
  #   "unrar",
  #   "zoo",
  #   "nomarch",
  #   "lzop",
  #   "cabextract",
  #   "p7zip-full",
  #   "rpm",
  #   "pax",
  #   "alien",
  #   "htop",
  #   "lsof",
  #   "tofrodos",
  #   "recode",
  #   "fetchmail",
  #   "ca-certificates",
  #   "mutt",
  #   "vacation",
  #   "bc",
  #   "manpages-de-dev",
  #   "lftp",
  #   "python",
  #   "tcpdump",
  #   "w3m",
  #   "unzip",
  #´   "strace",
  #  "subversion",
  #   "cvs",
  #   "openbsd-inetd",
  #   "iproute",
  #   "etherwake",
  #   "smbclient",
  #   "smbfs",
  #   "geoip-bin",
  #   "scponly",
  #   "rar",
  #   "git-core",
  #   "landscape-common",
  #   "openssh-blacklist",
  #   "openssh-blacklist-extra",
  #   "openssl-blacklist",
  #   "openssl-blacklist-extra",
  #   "openvpn-blacklist",
  #   "traceroute",
  #   "whois",
  #   "chkrootkit",
  #   "rkhunter",
  #   "curl",
  #   "ethstatus",
  #   "nload",
  #   "iftop",
  #   "joe",
  #   "sysstat",
  #   "apparmor-profiles",
  #   "ethtool"
  #   ]:
  #     ensure => installed;
  #   
  #}
  
  #######################################################################
  #######################################################################
  # apt-listchanges
  #file {
  #  "/etc/apt/listchanges.conf":
  #    mode => 0644, owner => root, group => root,
  #    before => Package[apt-listchanges],
  #    source => "puppet:///modules/ubuntu-base/apt-listchanges.conf";
  #
  #}
  
  #######################################################################
  #######################################################################
  # Locales
  #package { locales: ensure => installed }
  #file {
  #  "/etc/default/locale":
  #    mode => 0644, owner => root, group => root,
  #    source => "puppet:///modules/ubuntu-base/default_locale";
  #  "/etc/locale.gen":
  #    mode => 0644, owner => root, group => root,
  #    source => "puppet:///modules/ubuntu-base/locale.gen";
  #}
  #exec { "/usr/sbin/locale-gen":
  #  refreshonly => true,
  #  require => Package[locales],
  #  subscribe => File["/etc/locale.gen"]
  #}
  
  #######################################################################
  #######################################################################
  # remove all local bucketed files after a month.
  tidy { '/var/lib/puppet/clientbucket':
    backup => false,
    recurse => true,
    rmdirs => true,
    type => mtime,
    age => '4w',
  }
  
  #######################################################################
  #######################################################################
  # Cracklib
  #package {
  #  ["libpam-cracklib",
  #   "wamerican",
  #   "wamerican-huge",     
  #   "wamerican-large",
  #   "wamerican-small",
  #   "wbrazilian",
  #   "wbritish",
  #   "wbritish-huge",
  #   "wbritish-large",
  #   "wbritish-small",
  #   "wbulgarian",
  #   "wcanadian",
  #   "wcanadian-huge",
  #   "wcanadian-large",
  #   "wcanadian-small",
  #   "wcatalan",
  #   "wdanish",
  #   "wdutch",
  #   "wfaroese",
  #   "wfinnish",
  #   "wfrench",
  #   "wgaelic",
  #   "wgalician-minimos",
  #   "wirish",
  #   "witalian",
  #   "wmanx",
  #   "wngerman",
  #   "wnorwegian",
  #   "wogerman",
  #   "wpolish",
  #   "wportuguese",
  #   "wspanish",
  #   "wswedish",
  #   "wswiss",
  #   "wukrainian"
  #   ]:
    #	       ensure => installed
    #  }
    #  exec { "/etc/cron.daily/cracklib-runtime":
    #    refreshonly => true
    #  }
  
  ######################################################################
  ######################################################################
  # Emacs
  #package {["emacs23-nox", "puppet-el", "emacs-goodies-el"]:
  #  ensure => installed,
  #}
  
  ######################################################################
  # Apt-Defaults
  exec { "apt-update":
    command     => "/usr/bin/apt-get update",
    refreshonly => true;
  }
  #cron { "apt-update":
  #  command => "/usr/bin/apt-get update",
  #  user    => root,
  #  hour    => 22,
  #  minute  => 0;
  #}
  # I don't want kernel upgrades to happen automatically, since I need to schedule
  # reboots around others' work:
  #exec { "hold-kernels":
  #  command => "for name in `dpkg --get-selections | grep linux-image | grep -v hold | awk '{print \$1}'`; do echo \$name hold | dpkg --set-selections; done",
  #  onlyif  => "dpkg --get-selections | grep linux-image | grep -q install"
  #}
  
  file {
    "sources.list.d":
      path     => "/etc/apt/sources.list.d",
      ensure   => directory,
      checksum => md5,
      owner    => root,
      group    => root,
      mode     => 0755;
  }
}

define aptrepo (
  $apt_dir = "/etc/apt/",
  $sources_dir = "/etc/apt/sources.list.d",
  $source_type = "deb",
  $uri = "",
  $distribution = "${lsbdistcodename}",
  $component = "main",
  $key = ""
  ) {
  file {
    "aptrepo_${name}":
      path => "${sources_dir}/${name}.list",
      content => "${source_type} ${uri} ${distribution} ${component}\n",
      owner   => root,
      group   => root,
      mode    => 0644,
      ensure  => present,
      notify  => Exec["apt-update"];
  }
  if ($key) {
    exec {
      "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${key}":
        unless => "apt-key list | grep ${key}",
        notify => Exec["apt-update"],
    }
  }
}

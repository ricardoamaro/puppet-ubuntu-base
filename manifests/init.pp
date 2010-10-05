class ubuntu-base {

	case $operatingsystem {
		'Ubuntu': { }
		default: { fail("\$operatingsystem of ${fqdn} is not 'Ubuntu' but '${operatingsystem}'.") }
	}

	# Save space here: vservers don't need old packages around, there will
	# be always network around to fix them
	$apt_clean = $vserver ? { 
		'guest' => 'always',
		default => 'auto',
	}

	#######################################################################
	#######################################################################

	package {
		[
			apticron,
			apt-listchanges,
			screen, mmv, deborphan, less, iproute, bzip2,
			net-tools, man-db,
			sudo, pwgen,
			reportbug,
			pciutils,
			bash-completion
		]:
			ensure => installed;
		debconf-english:
			ensure => installed, before => Package[debconf-i18n];
		debconf-i18n:
			ensure => purged;
		[
			lpr, ppp, pppconfig, pppoe, pppoeconf,
			tasksel, tasksel-data, installation-report,
			dmidecode, laptop-detect, whiptail, info,
			pidentd, pump, nfs-common, nfs-kernel-server, nagios-nrpe-server
		]:
			ensure => purged;
	}

	#######################################################################
	#######################################################################

	# various config files
	file {
		"/etc/apt/listchanges.conf":
			mode => 0644, owner => root, group => root,
			#before => [ File[apt_config], Package[apt-listchanges] ],
			before => Package[apt-listchanges],
			source => "puppet:///modules/ubuntu-base/apt-listchanges.conf";
		#"/etc/hosts":
		#	mode => 0644, owner => root, group => root,
		#	source => "puppet:///modules/dbp/hosts";
	}
	
	#######################################################################
	#######################################################################

	package { locales: ensure => installed }
	file {
		"/etc/default/locale":
			mode => 0644, owner => root, group => root,
			source => "puppet:///modules/ubuntu-base/default_locale";
		"/etc/locale.gen":
			mode => 0644, owner => root, group => root,
			source => "puppet:///modules/ubuntu-base/locale.gen";
	}
	exec { "/usr/sbin/locale-gen":
		refreshonly => true,
		require => Package[locales],
		subscribe => File["/etc/locale.gen"]
	}

	#######################################################################
	#######################################################################

	#puppet::munin::resources { $fqdn: }

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

	package { ["libpam-cracklib", "wamerican", "wamerican-huge",
		   "wamerican-large", "wamerican-small", "wbrazilian",
		   "wbritish", "wbritish-huge", "wbritish-large",
		   "wbritish-small", "wbulgarian", "wcanadian",
		   "wcanadian-huge", "wcanadian-large", "wcanadian-small",
		   "wcatalan", "wdanish", "wdutch", "wfaroese", "wfinnish",
		   "wfrench", "wgaelic", "wgalician-minimos", "wirish",
		   "witalian", "wmanx", "wngerman", "wnorwegian", "wogerman",
		   "wpolish", "wportuguese", "wspanish", "wswedish", "wswiss",
		   "wukrainian"]:
		ensure => installed
	}
	exec { "/etc/cron.daily/cracklib-runtime":
		refreshonly => true
	}

}

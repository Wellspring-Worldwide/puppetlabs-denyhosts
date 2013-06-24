class denyhosts (
  $adminemail = "root@localhost",
  $allow      = [],
  $secure_log = $denyhosts::params::secure_log,
  $hosts_deny = '/etc/hosts.deny',
  $purge_deny = '',
  $purge_threshold = undef,
  $block_service = 'sshd',
  $deny_threshold_invalid = '5',
  $deny_threshold_valid = '10',
  $deny_threshold_root = '1',
  $deny_threshold_restricted = '1',
  $work_dir = '/var/lib/denyhosts',
  $suspicious_login_report_allowed_hosts = 'YES',
  $hostname_lookup = 'YES',
  $lock_file = $denyhosts::params::lock_file,
  $smtp_host = 'localhost',
  $smtp_port = '25',
  $smtp_username = undef,
  $smtp_password = undef,
  $smtp_from = undef,
  $smtp_subject = undef,
  $smtp_date_format = undef,
  $syslog_report = undef,
  $allowed_hosts_hostname_lookup = undef,
  $age_reset_valid = undef,
  $age_reset_root = undef,
  $age_reset_restricted = undef,
  $age_reset_invalid = undef,
  $reset_on_success = undef,
  $plugin_deny = undef,
  $plugin_purge = undef,
  $userdef_failed_entry_regex = undef,
  $daemon_log = undef,
  $daemon_log_time_format = undef,
  $daemon_log_message_format = undef,
  $daemon_sleep = undef,
  $daemon_purge = undef,
  $sync_server = undef,
  $sync_interval = undef,
  $sync_upload = undef,
  $sync_download = undef,
  $sync_download_threshold = undef,
  $sync_download_resiliency = undef
  ) inherits denyhosts::params {

  validate_array($allow)

  package { "denyhosts": ensure => installed; }

  file { "/etc/denyhosts.conf":
    owner   => root,
    group   => root,
    mode    => 644,
    content => template("denyhosts/denyhosts.conf.erb"),
    notify  => Service["denyhosts"],
  }

  service {
    "denyhosts":
      ensure    => running,
      enable    => true,
      hasstatus => false,
      pattern   => "denyhosts",
      require   => Package["denyhosts"],
  }

  file {
    "/etc/hosts.allow":
      content => template("denyhosts/hosts.allow.erb"),
      owner   => root,
      group   => root,
      mode    => 644,
  }

}

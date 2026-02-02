# paw_ansible_role_solr
# @summary Manage paw_ansible_role_solr configuration
#
# @param solr_workspace
# @param solr_create_user
# @param solr_user
# @param solr_group
# @param solr_version
# @param solr_mirror
# @param solr_remove_cruft
# @param solr_service_manage
# @param solr_service_name
# @param solr_service_state
# @param solr_install_dir
# @param solr_install_path
# @param solr_home
# @param solr_connect_host
# @param solr_port
# @param solr_xms
# @param solr_xmx
# @param solr_timezone
# @param solr_opts
# @param solr_cores
# @param solr_default_core_path
# @param solr_config_file
# @param solr_restart_handler_enabled
# @param par_vardir Base directory for Puppet agent cache (uses lookup('paw::par_vardir') for common config)
# @param par_tags An array of Ansible tags to execute (optional)
# @param par_skip_tags An array of Ansible tags to skip (optional)
# @param par_start_at_task The name of the task to start execution at (optional)
# @param par_limit Limit playbook execution to specific hosts (optional)
# @param par_verbose Enable verbose output from Ansible (optional)
# @param par_check_mode Run Ansible in check mode (dry-run) (optional)
# @param par_timeout Timeout in seconds for playbook execution (optional)
# @param par_user Remote user to use for Ansible connections (optional)
# @param par_env_vars Additional environment variables for ansible-playbook execution (optional)
# @param par_logoutput Control whether playbook output is displayed in Puppet logs (optional)
# @param par_exclusive Serialize playbook execution using a lock file (optional)
class paw_ansible_role_solr (
  String $solr_workspace = '/root',
  Boolean $solr_create_user = true,
  String $solr_user = 'solr',
  String $solr_group = '{{ solr_user }}',
  String $solr_version = '8.11.2',
  String $solr_mirror = 'https://archive.apache.org/dist',
  Boolean $solr_remove_cruft = false,
  Boolean $solr_service_manage = true,
  String $solr_service_name = 'solr',
  String $solr_service_state = 'started',
  String $solr_install_dir = '/opt',
  String $solr_install_path = '/opt/{{ solr_service_name }}',
  String $solr_home = '/var/{{ solr_service_name }}',
  String $solr_connect_host = 'localhost',
  String $solr_port = '8983',
  String $solr_xms = '256M',
  String $solr_xmx = '512M',
  String $solr_timezone = 'UTC',
  String $solr_opts = '$SOLR_OPTS -Dlog4j2.formatMsgNoLookups=true',
  Array $solr_cores = ['collection1'],
  String $solr_default_core_path = '{% if solr_version.split(\'.\')[0] < \'9\' %}{{ solr_install_path }}/example/files/conf/{% else %}{{ solr_install_path }}/server/solr/configsets/_default/conf/{% endif %}',
  String $solr_config_file = '/etc/default/{{ solr_service_name }}.in.sh',
  Boolean $solr_restart_handler_enabled = true,
  Optional[Stdlib::Absolutepath] $par_vardir = undef,
  Optional[Array[String]] $par_tags = undef,
  Optional[Array[String]] $par_skip_tags = undef,
  Optional[String] $par_start_at_task = undef,
  Optional[String] $par_limit = undef,
  Optional[Boolean] $par_verbose = undef,
  Optional[Boolean] $par_check_mode = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[String] $par_user = undef,
  Optional[Hash] $par_env_vars = undef,
  Optional[Boolean] $par_logoutput = undef,
  Optional[Boolean] $par_exclusive = undef
) {
# Execute the Ansible role using PAR (Puppet Ansible Runner)
# Playbook synced via pluginsync to agent's cache directory
# Check for common paw::par_vardir setting, then module-specific, then default
  $_par_vardir = $par_vardir ? {
    undef   => lookup('paw::par_vardir', Stdlib::Absolutepath, 'first', '/opt/puppetlabs/puppet/cache'),
    default => $par_vardir,
  }
  $playbook_path = "${_par_vardir}/lib/puppet_x/ansible_modules/ansible_role_solr/playbook.yml"

  par { 'paw_ansible_role_solr-main':
    ensure        => present,
    playbook      => $playbook_path,
    playbook_vars => {
      'solr_workspace'               => $solr_workspace,
      'solr_create_user'             => $solr_create_user,
      'solr_user'                    => $solr_user,
      'solr_group'                   => $solr_group,
      'solr_version'                 => $solr_version,
      'solr_mirror'                  => $solr_mirror,
      'solr_remove_cruft'            => $solr_remove_cruft,
      'solr_service_manage'          => $solr_service_manage,
      'solr_service_name'            => $solr_service_name,
      'solr_service_state'           => $solr_service_state,
      'solr_install_dir'             => $solr_install_dir,
      'solr_install_path'            => $solr_install_path,
      'solr_home'                    => $solr_home,
      'solr_connect_host'            => $solr_connect_host,
      'solr_port'                    => $solr_port,
      'solr_xms'                     => $solr_xms,
      'solr_xmx'                     => $solr_xmx,
      'solr_timezone'                => $solr_timezone,
      'solr_opts'                    => $solr_opts,
      'solr_cores'                   => $solr_cores,
      'solr_default_core_path'       => $solr_default_core_path,
      'solr_config_file'             => $solr_config_file,
      'solr_restart_handler_enabled' => $solr_restart_handler_enabled,
    },
    tags          => $par_tags,
    skip_tags     => $par_skip_tags,
    start_at_task => $par_start_at_task,
    limit         => $par_limit,
    verbose       => $par_verbose,
    check_mode    => $par_check_mode,
    timeout       => $par_timeout,
    user          => $par_user,
    env_vars      => $par_env_vars,
    logoutput     => $par_logoutput,
    exclusive     => $par_exclusive,
  }
}

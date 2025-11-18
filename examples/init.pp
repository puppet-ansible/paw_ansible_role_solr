# Example usage of paw_ansible_role_solr

# Simple include with default parameters
include paw_ansible_role_solr

# Or with custom parameters:
# class { 'paw_ansible_role_solr':
#   solr_service_name => 'solr',
#   solr_install_path => '/opt/{{ solr_service_name }}',
#   solr_home => '/var/{{ solr_service_name }}',
#   solr_host => '0.0.0.0',
#   solr_port => '8983',
#   solr_xms => '256M',
#   solr_xmx => '512M',
#   solr_log_file_path => '/var/log/solr.log',
#   solr_user => 'solr',
#   solr_workspace => '/root',
#   solr_create_user => true,
#   solr_group => '{{ solr_user }}',
#   solr_version => '8.11.2',
#   solr_mirror => 'https://archive.apache.org/dist',
#   solr_remove_cruft => false,
#   solr_service_manage => true,
#   solr_service_state => 'started',
#   solr_install_dir => '/opt',
#   solr_connect_host => 'localhost',
#   solr_timezone => 'UTC',
#   solr_opts => '$SOLR_OPTS -Dlog4j2.formatMsgNoLookups=true',
#   solr_cores => ['collection1'],
#   solr_default_core_path => '{% if solr_version.split(\'.\')[0] < \'9\' %}{{ solr_install_path }}/example/files/conf/{% else %}{{ solr_install_path }}/server/solr/configsets/_default/conf/{% endif %}',
#   solr_config_file => '/etc/default/{{ solr_service_name }}.in.sh',
#   solr_restart_handler_enabled => true,
# }

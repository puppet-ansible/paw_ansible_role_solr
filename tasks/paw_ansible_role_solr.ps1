# Puppet task for executing Ansible role: ansible_role_solr
# This script runs the entire role via ansible-playbook

$ErrorActionPreference = 'Stop'

# Determine the ansible modules directory
if ($env:PT__installdir) {
  $AnsibleDir = Join-Path $env:PT__installdir "lib\puppet_x\ansible_modules\ansible_role_solr"
} else {
  # Fallback to Puppet cache directory
  $AnsibleDir = "C:\ProgramData\PuppetLabs\puppet\cache\lib\puppet_x\ansible_modules\ansible_role_solr"
}

# Check if ansible-playbook is available
$AnsiblePlaybook = Get-Command ansible-playbook -ErrorAction SilentlyContinue
if (-not $AnsiblePlaybook) {
  $result = @{
    _error = @{
      msg = "ansible-playbook command not found. Please install Ansible."
      kind = "puppet-ansible-converter/ansible-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Check if the role directory exists
if (-not (Test-Path $AnsibleDir)) {
  $result = @{
    _error = @{
      msg = "Ansible role directory not found: $AnsibleDir"
      kind = "puppet-ansible-converter/role-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
$CollectionPlaybook = Join-Path $AnsibleDir "roles\paw_ansible_role_solr\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\paw_ansible_role_solr"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\paw_ansible_role_solr"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_solr_workspace) {
  $ExtraVars['solr_workspace'] = $env:PT_solr_workspace
}
if ($env:PT_solr_create_user) {
  $ExtraVars['solr_create_user'] = $env:PT_solr_create_user
}
if ($env:PT_solr_user) {
  $ExtraVars['solr_user'] = $env:PT_solr_user
}
if ($env:PT_solr_group) {
  $ExtraVars['solr_group'] = $env:PT_solr_group
}
if ($env:PT_solr_version) {
  $ExtraVars['solr_version'] = $env:PT_solr_version
}
if ($env:PT_solr_mirror) {
  $ExtraVars['solr_mirror'] = $env:PT_solr_mirror
}
if ($env:PT_solr_remove_cruft) {
  $ExtraVars['solr_remove_cruft'] = $env:PT_solr_remove_cruft
}
if ($env:PT_solr_service_manage) {
  $ExtraVars['solr_service_manage'] = $env:PT_solr_service_manage
}
if ($env:PT_solr_service_name) {
  $ExtraVars['solr_service_name'] = $env:PT_solr_service_name
}
if ($env:PT_solr_service_state) {
  $ExtraVars['solr_service_state'] = $env:PT_solr_service_state
}
if ($env:PT_solr_install_dir) {
  $ExtraVars['solr_install_dir'] = $env:PT_solr_install_dir
}
if ($env:PT_solr_install_path) {
  $ExtraVars['solr_install_path'] = $env:PT_solr_install_path
}
if ($env:PT_solr_home) {
  $ExtraVars['solr_home'] = $env:PT_solr_home
}
if ($env:PT_solr_connect_host) {
  $ExtraVars['solr_connect_host'] = $env:PT_solr_connect_host
}
if ($env:PT_solr_port) {
  $ExtraVars['solr_port'] = $env:PT_solr_port
}
if ($env:PT_solr_xms) {
  $ExtraVars['solr_xms'] = $env:PT_solr_xms
}
if ($env:PT_solr_xmx) {
  $ExtraVars['solr_xmx'] = $env:PT_solr_xmx
}
if ($env:PT_solr_timezone) {
  $ExtraVars['solr_timezone'] = $env:PT_solr_timezone
}
if ($env:PT_solr_opts) {
  $ExtraVars['solr_opts'] = $env:PT_solr_opts
}
if ($env:PT_solr_cores) {
  $ExtraVars['solr_cores'] = $env:PT_solr_cores
}
if ($env:PT_solr_default_core_path) {
  $ExtraVars['solr_default_core_path'] = $env:PT_solr_default_core_path
}
if ($env:PT_solr_config_file) {
  $ExtraVars['solr_config_file'] = $env:PT_solr_config_file
}
if ($env:PT_solr_restart_handler_enabled) {
  $ExtraVars['solr_restart_handler_enabled'] = $env:PT_solr_restart_handler_enabled
}

$ExtraVarsJson = $ExtraVars | ConvertTo-Json -Compress

# Execute ansible-playbook with the role
Push-Location $PlaybookDir
try {
  ansible-playbook playbook.yml `
    --extra-vars $ExtraVarsJson `
    --connection=local `
    --inventory=localhost, `
    2>&1 | Write-Output
  
  $ExitCode = $LASTEXITCODE
  
  if ($ExitCode -eq 0) {
    $result = @{
      status = "success"
      role = "ansible_role_solr"
    }
  } else {
    $result = @{
      status = "failed"
      role = "ansible_role_solr"
      exit_code = $ExitCode
    }
  }
  
  Write-Output ($result | ConvertTo-Json)
  exit $ExitCode
}
finally {
  Pop-Location
}

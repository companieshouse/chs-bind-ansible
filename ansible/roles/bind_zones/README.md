<!-- DOCSIBLE START -->

# 📃 Role overview

## bind_zones



Description: Manage BIND DNS zone files

| Field                | Value           |
|--------------------- |-----------------|
| Readme update        | 2026/08/05 |








### Defaults

**These are static variables with lower priority**

#### File: defaults/main.yml

| Var          | Type         | Value       |
|--------------|--------------|-------------|
| [bind_zones_dir](defaults/main.yml#L4)   | str | `/var/named` |    
| [bind_zones_owner](defaults/main.yml#L6)   | str | `named` |    
| [bind_zones_group](defaults/main.yml#L7)   | str | `named` |    
| [bind_zones_dir_mode](defaults/main.yml#L8)   | str | `{{ bind_zones_directory_mode }}` |    
| [bind_zones_file_mode](defaults/main.yml#L9)   | str | `{{ bind_zones_file_mode }}` |    
| [bind_zones_git_repo](defaults/main.yml#L13)   | str |  |    
| [bind_zones_git_branch](defaults/main.yml#L14)   | str | `main` |    
| [bind_zones_git_checkout_dir](defaults/main.yml#L15)   | str | `/opt/bind-zones` |    
| [bind_zones_git_key_file](defaults/main.yml#L18)   | str |  |    
| [bind_zones_git_accept_hostkey](defaults/main.yml#L19)   | bool | `True` |    
| [bind_zones_service_name](defaults/main.yml#L22)   | str | `named` |    
| [bind_zones_bind_manage_service](defaults/main.yml#L23)   | bool | `True` |    





### Tasks


#### File: tasks/main.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Ensure zone directory exists | ansible.builtin.file | False |
| Ensure git checkout directory exists | ansible.builtin.file | False |
| Validate git configuration | ansible.builtin.assert | False |
| Checkout zone repository | ansible.builtin.git | False |
| Check zones.yml exists | ansible.builtin.stat | False |
| Read zones.yml from remote host | ansible.builtin.slurp | False |
| Parse zones.yml | ansible.builtin.set_fact | False |
| Select zones for current environment | ansible.builtin.set_fact | False |
| Deploy zones.conf | ansible.builtin.template | False |
| Create zone directories | ansible.builtin.file | False |
| Copy zone files | ansible.builtin.copy | False |
| Validate zone files | ansible.builtin.command | False |
| Validate BIND configuration | ansible.builtin.command | False |







## Author Information
Companies House

#### License

MIT

#### Minimum Ansible Version

2.15

#### Platforms

- **EL**: ['8', '9']


#### Dependencies

No dependencies specified.
<!-- DOCSIBLE END -->

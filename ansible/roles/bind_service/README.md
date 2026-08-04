<!-- DOCSIBLE START -->

# 📃 Role overview

## bind_service



Description: Manage BIND DNS zone files

| Field                | Value           |
|--------------------- |-----------------|
| Readme update        | 2026/08/04 |








### Defaults

**These are static variables with lower priority**

#### File: defaults/main.yml

| Var          | Type         | Value       |
|--------------|--------------|-------------|
| [bind_service_records](defaults/main.yml#L3)   | list | `[]` |    
| [bind_service_zone_dir](defaults/main.yml#L6)   | str | `/var/named` |    
| [bind_service_zone_owner](defaults/main.yml#L7)   | str | `root` |    
| [bind_service_zone_group](defaults/main.yml#L8)   | str | `named` |    
| [bind_service_zone_mode](defaults/main.yml#L9)   | str | `0644` |    
| [bind_service_validate_zones](defaults/main.yml#L12)   | bool | `True` |    
| [bind_service_auto_ptr](defaults/main.yml#L15)   | bool | `True` |    
| [bind_service_lock_file](defaults/main.yml#L18)   | str | `/var/lock/bind.lock` |    
| [bind_service_lock_owner](defaults/main.yml#L19)   | str | `root` |    
| [bind_service_lock_group](defaults/main.yml#L20)   | str | `root` |    
| [bind_service_lock_mode](defaults/main.yml#L21)   | str | `0644` |    
| [bind_service_manage_records](defaults/main.yml#L24)   | bool | `True` |    
| [bind_service_manage_ptr](defaults/main.yml#L25)   | bool | `True` |    
| [bind_service_update_serial](defaults/main.yml#L26)   | bool | `True` |    
| [bind_service_name](defaults/main.yml#L29)   | str | `named` |    
| [bind_service_reload_state](defaults/main.yml#L30)   | str | `reloaded` |    
| [bind_service_restart_state](defaults/main.yml#L31)   | str | `restarted` |    
| [bind_service_checkzone_command](defaults/main.yml#L34)   | str | `/usr/sbin/named-checkzone` |    
| [bind_service_checkconf_command](defaults/main.yml#L35)   | str | `/usr/sbin/named-checkconf` |    





### Tasks


#### File: tasks/main.yml

| Name | Module | Has Conditions | Tags |
| ---- | ------ | -------------- | -----|
| Acquire lock | ansible.builtin.file | False |  |
| Read zones.yml from remote host | ansible.builtin.slurp | False |  |
| Show raw zones.yml | ansible.builtin.debug | False |  |
| Parse zones.yml | ansible.builtin.set_fact | False |  |
| Debug bind_zone_definitions | ansible.builtin.debug | False |  |
| Manage service records | ansible.builtin.include_tasks | True | records |
| Manage PTR records | ansible.builtin.include_tasks | True |  |
| Update zone serials | ansible.builtin.include_tasks | True |  |
| Validate zones | ansible.builtin.include_tasks | True |  |
| Release lock | ansible.builtin.file | False |  |

#### File: tasks/ptr.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Generate PTR records | ansible.builtin.lineinfile | False |

#### File: tasks/record_update.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Debug bind_environment | ansible.builtin.debug | False |
| Debug bind_zone_definitions | ansible.builtin.debug | False |
| Find matching zone definitions | ansible.builtin.set_fact | False |
| Debug matching zones | ansible.builtin.debug | False |
| Assert matching zone exists | ansible.builtin.assert | False |
| Set zone definition | ansible.builtin.set_fact | False |
| Assert zone definition found | ansible.builtin.assert | False |
| Debug bind_service_zone_dir | ansible.builtin.debug | False |
| Debug bind_service_zone_definition | ansible.builtin.debug | False |
| Read current zone | ansible.builtin.slurp | False |
| Show zones.yml contents | ansible.builtin.debug | False |
| Unnamed_block | block | False |
| Create work copy | ansible.builtin.copy | False |
| Ensure zone ends with newline | ansible.builtin.lineinfile | False |
| Check if record exists | ansible.builtin.shell | False |
| Debug existing record result | ansible.builtin.debug | False |
| Add DNS record | ansible.builtin.lineinfile | False |
| Validate updated zone | ansible.builtin.command | False |
| Validate full DNS configuration | ansible.builtin.command | False |
| Promote validated zone | ansible.builtin.command | False |

#### File: tasks/records.yml

| Name | Module | Has Conditions | Tags |
| ---- | ------ | -------------- | -----|
| Process DNS record changes | ansible.builtin.include_tasks | False | record_update |
| Log DNS changes | ansible.builtin.lineinfile | False |  |

#### File: tasks/serial.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Update zone serial | ansible.builtin.replace | False |
| Validate all record zones exist in zones.yml | ansible.builtin.assert | False |

#### File: tasks/validate.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Validate DNS zones | ansible.builtin.command | False |







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

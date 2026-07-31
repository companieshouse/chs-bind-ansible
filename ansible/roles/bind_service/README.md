<!-- DOCSIBLE START -->

# 📃 Role overview

## bind_service



Description: role to manage bind service

| Field                | Value           |
|--------------------- |-----------------|
| Readme update        | 2026/07/20 |








### Defaults

**These are static variables with lower priority**

#### File: defaults/main.yml

| Var          | Type         | Value       |
|--------------|--------------|-------------|
| [bind_service_records](defaults/main.yml#L1)   | list | `[]` |    
| [bind_service_zone_dir](defaults/main.yml#L2)   | str | `/var/named` |    
| [bind_service_zone_owner](defaults/main.yml#L4)   | str | `root` |    
| [bind_service_zone_group](defaults/main.yml#L5)   | str | `named` |    
| [bind_service_zone_mode](defaults/main.yml#L6)   | str | `0644` |    
| [bind_service_validate_zones](defaults/main.yml#L8)   | bool | `True` |    
| [bind_service_auto_ptr](defaults/main.yml#L9)   | bool | `True` |    
| [bind_service_lock_file](defaults/main.yml#L10)   | str | `/var/lock/bind.lock` |    
| [bind_service_lock_owner](defaults/main.yml#L13)   | str | `root` |    
| [bind_service_lock_group](defaults/main.yml#L14)   | str | `root` |    
| [bind_service_lock_mode](defaults/main.yml#L15)   | str | `0644` |    





### Tasks


#### File: tasks/main.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Acquire lock | ansible.builtin.file | False |
| Manage service records | ansible.builtin.include_tasks | False |
| Manage PTR records | ansible.builtin.include_tasks | True |
| Update serial | ansible.builtin.include_tasks | False |
| Validate zones | ansible.builtin.include_tasks | True |
| Release lock | ansible.builtin.file | False |

#### File: tasks/ptr.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Generate PTR records | ansible.builtin.lineinfile | False |

#### File: tasks/records.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Update zone records (atomic) | block | False |
| Read current zone | ansible.builtin.slurp | False |
| Modify zone content | ansible.builtin.set_fact | False |
| Write new zone file (atomic) | ansible.builtin.copy | False |
| Replace zone file | ansible.builtin.copy | False |
| Remove temporary file | ansible.builtin.file | False |
| Log DNS change | ansible.builtin.lineinfile | False |

#### File: tasks/serial.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Update zone serial | ansible.builtin.replace | False |

#### File: tasks/validate.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Validate DNS zones | ansible.builtin.command | False |







## Author Information
Companies House

#### License

No license specified.

#### Minimum Ansible Version

2.15

#### Platforms

No platforms specified.

#### Dependencies

No dependencies specified.
<!-- DOCSIBLE END -->

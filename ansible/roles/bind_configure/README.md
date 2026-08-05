<!-- DOCSIBLE START -->

# 📃 Role overview

## bind_configure



Description: configure bind nameserver

| Field                | Value           |
|--------------------- |-----------------|
| Readme update        | 2026/07/21 |








### Defaults

**These are static variables with lower priority**

#### File: defaults/main.yml

| Var          | Type         | Value       |
|--------------|--------------|-------------|
| [bind_configure_role](defaults/main.yml#L2)   | str | `master` |    
| [bind_configure_listen_ipv4](defaults/main.yml#L4)   | list | `[]` |    
| [bind_configure_listen_ipv4.**0**](defaults/main.yml#L5)   | str | `127.0.0.1` |    
| [bind_configure_listen_ipv4.**1**](defaults/main.yml#L6)   | str | `{{ ansible_default_ipv4.address }}` |    
| [bind_configure_allow_query](defaults/main.yml#L8)   | list | `[]` |    
| [bind_configure_allow_query.**0**](defaults/main.yml#L9)   | str | `any` |    
| [bind_configure_allow_transfer](defaults/main.yml#L11)   | list | `[]` |    
| [bind_configure_allow_transfer.**0**](defaults/main.yml#L12)   | str | `none` |    
| [bind_configure_masters](defaults/main.yml#L14)   | list | `[]` |    
| [bind_configure_named_conf](defaults/main.yml#L16)   | str | `/etc/named.conf` |    
| [bind_configure_service_name](defaults/main.yml#L18)   | str | `named` |    





### Tasks


#### File: tasks/main.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Validate role type | ansible.builtin.assert | False |
| Validate slave masters are defined | ansible.builtin.assert | True |
| Gather service facts | ansible.builtin.service_facts | False |
| Validate named service is available | ansible.builtin.assert | False |
| Deploy named.conf | ansible.builtin.template | False |







## Author Information
Companies House

#### License

No license specified.

#### Minimum Ansible Version

2.15

#### Platforms

No platforms specified.

#### Dependencies

- **bind_install**
  
  

<!-- DOCSIBLE END -->

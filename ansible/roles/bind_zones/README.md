<!-- DOCSIBLE START -->

# 📃 Role overview

## bind_zones



Description: role to update zone file

| Field                | Value           |
|--------------------- |-----------------|
| Readme update        | 2026/07/21 |








### Defaults

**These are static variables with lower priority**

#### File: defaults/main.yml

| Var          | Type         | Value       |
|--------------|--------------|-------------|
| [bind_zones_dir](defaults/main.yml#L1)   | str | `/var/named` |    
| [bind_zones_bucket](defaults/main.yml#L2)   | str | `chs-bind-zones-dev` |    
| [bind_zones_s3_prefix](defaults/main.yml#L3)   | str | `zones` |    





### Tasks


#### File: tasks/main.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Ensure zone directory exists | ansible.builtin.file | False |
| Sync zones from S3 (authoritative source) | ansible.builtin.command | False |
| Validate zone files | ansible.builtin.command | False |
| Reload named after zone update | ansible.builtin.service | True |







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

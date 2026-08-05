<!-- DOCSIBLE START -->

# 📃 Role overview

## bind_install





| Field                | Value           |
|--------------------- |-----------------|
| Readme update        | 2026/07/21 |














### Tasks


#### File: tasks/main.yml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Install BIND packages | ansible.builtin.package | False |
| Gather package facts | ansible.builtin.package_facts | False |
| Validate BIND packages are installed | ansible.builtin.assert | False |
| Gather service facts | ansible.builtin.service_facts | False |
| Verify named service exists | ansible.builtin.assert | False |
| Enable and start named | ansible.builtin.service | False |
| Refresh service facts | ansible.builtin.service_facts | False |
| Assert named service is active | ansible.builtin.assert | False |









#### Dependencies

No dependencies specified.
<!-- DOCSIBLE END -->

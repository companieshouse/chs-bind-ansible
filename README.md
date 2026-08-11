
BIND DNS SERVICE

This repository provides a GitOps-based automation framework for managing BIND DNS infrastructure using Ansible.
The solution is separated into four independent roles, each with a clearly defined responsibility:

bind_install → package installation
bind_configure → core BIND configuration
bind_zones → zone file deployment
bind_service → DNS record lifecycle management


BIND DNS Automation
Overview

Role	Purposebind_install	Installs required BIND packages
bind_configure	Deploys and manages BIND configuration
bind_zones	Deploys DNS zone files
bind_service	Adds, updates, and removes DNS records

This separation ensures:

Architecture
Git Repository
      │
      ▼
Concourse Pipeline
      │
      ▼
Validate Zone Data
      │
      ▼
Ansible Playbooks
      │
      ├── bind_install
      ├── bind_configure
      ├── bind_zones
      └── bind_service
      │
      ▼
BIND DNS Servers

Repository Structure
ansible/
├── roles/
│   ├── bind_install/
│   ├── bind_configure/
│   ├── bind_zones/
│   └── bind_service/
│
├── group_vars/
│   └── all/
│       └── bind.yml
│
├── inventory/
│   ├── aws_ec2.yml
│   └── molecule-test.yml
│
├── playbooks/
   ├── install.yml
   ├── configure.yml
   ├── deploy_zones.yml
   └── record_update.yml



Role: bind_install
Purpose

Installs BIND and all required dependencies on target servers.

This role is responsible only for package installation and does not manage:

Configuration files
Zone files
DNS records
Responsibilities
Install BIND packages
Install utilities
Ensure package prerequisites exist
Example Task
- hosts: bind_servers
  become: true

  roles:
    - bind_install


Returns installed BIND version successfully.

Role: bind_configure
Purpose

Manages core BIND configuration.

This role deploys:

/etc/named.conf
/etc/named/



depending on the operating system.

Responsibilities
Deploy named.conf
Configure logging
Configure ACLs
Configure recursion settings
Configure zone includes
Validate configuration
Validation

Before service restart:

named-checkconf


must return successfully.

Example Playbook
- hosts: bind_servers
  become: true

  roles:
    - bind_configure

Expected Outcome
named-checkconf


returns:

No errors found

Role: bind_zones
Purpose

Manages authoritative DNS zone files.

This role is responsible for deploying complete zone files to DNS servers.

Responsibilities
Deploy forward zones
Deploy reverse zones
Validate zone syntax
Increment serial numbers
Trigger zone reloads
Example Zone
$TTL 300

@ IN SOA ns1.example.com. hostmaster.example.com. (
    2026081101
    3600
    900
    604800
    300
)

@       IN NS ns1.example.com.
www     IN A  10.20.30.40

Validation

Each zone is validated using:

named-checkzone example.com db.example.com

Example Playbook
- hosts: bind_primary

  roles:
    - bind_zones

Role: bind_service
Purpose

Provides dynamic DNS record lifecycle management.

Unlike bind_zones, which deploys full zone files, bind_service performs targeted record operations.

Supported actions:

Add record
Update record
Remove record
Responsibilities
Update existing zone files
Auto increment SOA serial
Validate zone
Reload BIND
Verify deployment
Supported Record Types
A
AAAA
CNAME
TXT
MX
PTR
SRV

Example Variables
bind_record_action: add

bind_zone_name: example.com

bind_record_name: api

bind_record_type: A

bind_record_value: 10.20.30.40

Add Record
- hosts: bind_primary

  roles:
    - role: bind_service
      vars:
        bind_record_action: add


Result:

api IN A 10.20.30.40

Remove Record
bind_record_action: remove


Removes:

api IN A 10.20.30.40


from the zone file.

Update Record

Current:

api IN A 10.20.30.40


Desired:

api IN A 10.20.30.50


Role updates the record and increments the serial number.

CI/CD Workflow
Validation Stage

Before deployment the pipeline should execute:

1. Serial Validation
serial-check.sh


Checks:

Serial exists
Serial format is valid
New serial is greater than existing
2. Zone Validation
named-checkzone.sh


Checks:

Zone syntax
Record format
Zone integrity
3. Configuration Validation
named-checkconf.sh


Checks:

BIND configuration syntax
Include files
Zone declarations
Example Concourse Workflow
Git Change
    │
    ▼
validate-zones
    │
    ▼
bind-service-record-update
    │
    ▼
bind-service-verify

Post Deployment Verification

After deployment verify the record exists.

Example:

dig @localhost api.example.com A +short


Expected:

10.20.30.40


Reverse lookup verification:

dig @localhost -x 10.20.30.40 +short


Expected:

api.example.com.

Testing
Molecule

Run role tests:

molecule test


Run a specific scenario:

molecule test -s bind_service_only

Ansible Lint
ansible-lint

YAML Validation
yamllint .

Operational Procedure
Adding a DNS Record

Update variables for:

Zone
Record name
Record type
Record value

Commit changes.

Submit Pull Request.

CI validation runs:

serial-check.sh
named-checkzone.sh
named-checkconf.sh

Merge Pull Request.

Concourse deploys record.

Verify using dig.

Removing a DNS Record
Set:
bind_record_action: remove


Commit changes.

Submit Pull Request.

Validation passes.

Deploy through pipeline.

Verify record no longer resolves.

Best Practices
Never modify DNS zones directly on servers.
Use Git as the single source of truth.
Always validate zones before deployment.
Keep role responsibilities separated.
Use variable-driven record updates.
Ensure serial numbers are incremented correctly.
Verify all changes post deployment.
Troubleshooting
Zone Validation Failure
named-checkzone example.com db.example.com


Review:

Missing dots
Invalid record types
Duplicate records
Invalid serial number
Configuration Validation Failure
named-checkconf


Review:

Includes
ACL definitions
Zone declarations
Record Not Resolving

Verify:

rndc reload


then:

dig @localhost <record>.<zone> +short


Check:

systemctl status named


or

systemctl status bind9


for service errors.

Support Model
Component	OwnershipPackage installation	bind_install
BIND configuration	bind_configure
Zone deployment	bind_zones
Record lifecycle management	bind_service
Validation scripts	CI/CD Pipeline
DNS verification	Post-deployment checks


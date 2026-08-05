# ansible-role-repository-template

A template repository to be used for setting up Ansible roles

##############################################

Below is a **production‑ready `README.md`** you can drop straight into your **`chs-bind-ansible`** repository.  
It documents the **three‑role design**, **S3‑authoritative zones**, and **master/slave behaviour** clearly and concisely.

***

# CHS BIND Ansible Configuration

This repository configures **BIND DNS servers** using **Ansible (ansible.builtin only)**.  
It is designed for **immutable infrastructure**, **CI/CD execution**, and **AWS environments** where **zone files are stored authoritatively in S3**.

***

## Overview

The solution is split into **three Ansible roles**, each with a single responsibility:

| Role             | Responsibility                                              |
| ---------------- | ----------------------------------------------------------- |
| `bind_install`   | Install BIND packages and manage the `named` service        |
| `bind_configure` | Configure BIND (`named.conf`) for master/slave and security |
| `bind_zones`     | Sync, validate, and reload DNS zone files from S3           |

This separation allows:

*   Safe re‑runs
*   Independent updates to zones without touching config
*   Clear CI pipeline stages

***

## Repository Structure

    chs-bind-ansible/
    ├── playbooks/
    │   └── site.yml
    ├── inventories/
    │   └── chs-dev/
    ├── group_vars/
    │   └── bind.yml
    └── roles/
        ├── bind_install/
        │   └── tasks/main.yml
        ├── bind_configure/
        │   ├── defaults/main.yml
        │   ├── tasks/main.yml
        │   ├── templates/named.conf.j2
        │   └── handlers/main.yml
        └── bind_zones/
            ├── defaults/main.yml
            ├── tasks/main.yml
            └── handlers/main.yml

***

## Playbook Execution

### `playbooks/site.yml`

yaml
- name: Configure BIND DNS servers
  hosts: bind_servers
  become: true

  roles:
    - bind_install
    - bind_configure
    - bind_zones


Execution order is **intentional**:

1.  Install packages
2.  Deploy and validate configuration
3.  Sync and validate zones

***

## Role Details

***

## Role: `bind_install`

### Purpose

*   Install `bind` and `bind-utils`
*   Enable and start the `named` service

### Key Characteristics

*   Idempotent
*   No environment‑specific logic
*   Safe to re‑run

***

## Role: `bind_configure`

### Purpose

*   Deploy `named.conf`
*   Configure master or slave behaviour
*   Apply security controls (ACLs, recursion, transfers)

### Example Defaults

yaml
bind_role: master   # master | slave

bind_listen_ipv4:
  - 127.0.0.1
  - "{{ ansible_default_ipv4.address }}"

bind_allow_query:
  - any

bind_allow_transfer:
  - none

bind_masters: []


### Validation

*   `named-checkconf` is run on every execution
*   Service restart is handler‑driven

***

## Role: `bind_zones`

### Purpose

*   Treat **S3 as the authoritative source of zone files**
*   Sync zones to `/var/named`
*   Validate zones before reload
*   Reload BIND safely

### Why S3?

*   Versioning and rollback
*   CI‑driven promotion
*   Single source of truth

### Key Defaults

yaml
bind_zone_dir: /var/named
bind_zone_bucket: chs-bind-zones-dev
bind_zone_s3_prefix: zones


### Zone Sync (Authoritative)

yaml
- name: Sync zones from S3 (authoritative source)
  ansible.builtin.command: >
    aws s3 sync
    s3://{{ bind_zone_bucket }}/{{ bind_zone_s3_prefix }}/
    {{ bind_zone_dir }}/
  changed_when: false

> **Note:**  
> Requires AWS CLI and an EC2 IAM role with read access to the S3 bucket.

***

### Zone Validation

yaml
- name: Validate zone files
  ansible.builtin.command: >
    named-checkzone {{ item.zone }} {{ bind_zone_dir }}/{{ item.file }}
  loop: "{{ bind_zones }}"
  changed_when: false


Validation runs **after sync and before reload**.

***

## Variables (`group_vars/bind.yml`)

bind_role: master

bind_zones:
  - zone: example.internal
    file: example.internal.zone

bind_allow_transfer:
  - 10.0.2.10

***

## Master / Slave Model

| Server Type | Behaviour                   |
| ----------- | --------------------------- |
| Master      | Pulls zones from S3         |
| Slave       | Uses master(s) via AXFR     |
| Zones       | Identical files             |
| Config      | Conditional via `bind_role` |

> Slaves **do not** pull from S3 unless explicitly configured.

***

## Security Model

*   No inbound SSH required (SSM recommended)
*   No dynamic DNS updates
*   Zone transfers explicitly restricted
*   Config and zones validated before reload
*   No shell scripts unless unavoidable

***

## CI/CD Integration

Typical pipeline flow:

    Zones updated → Uploaded to S3
            ↓
    Ansible bind_zones role
            ↓
    named-checkzone
            ↓
    named reload

No manual changes on servers.

***

## Requirements

*   Amazon Linux 2023 (or RHEL‑compatible)
*   `bind`, `bind-utils`
*   AWS CLI installed
*   EC2 IAM role with:
    *   `s3:GetObject`
    *   `s3:ListBucket`

***


*   One responsibility per role
*   Idempotency everywhere
*   Authoritative data sources
*   Validation before reload


## Summary

This repository provides a **clean, secure, and CI‑ready** approach to managing BIND DNS using Ansible, with **S3 as the single source of truth for zone data**.

***

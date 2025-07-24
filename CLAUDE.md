# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains infrastructure-as-code for creating DISA-STIG compliant RHEL8 virtual machines and deploying Ansible Automation Platform (AAP). The workflow uses Packer to build hardened VM images and Vagrant to create VMs from those images.

## Setup and Prerequisites

### Environment Setup
Run `source install.rc` to create a Python virtualenv with required Ansible packages. This sets up the development environment with all necessary dependencies.

### Required Files
- RHEL 8.5 ISO at `/Users/Shared/rhel-8.5-x86_64-dvd.iso` or Red Hat Customer Portal access
- AAP bundle installer and ansible.controller collection from Red Hat (place in `files/` directory)

## Common Commands

### Image Creation
- `make image` - Build DISA-STIG compliant RHEL8 image using Packer
- `make box` - Create Vagrant box from Packer output
- `make all` - Full workflow: clean, build image, create box, and provision VMs

### Development and Testing
- `make prepare` - Install Ansible dependencies, validate syntax, and run linting
- `make lint` - Validate Vagrant and Packer configurations
- `make clean` - Destroy VMs, remove boxes, and clean output directories

### Manual Execution
- `packer build rhel8.pkr.hcl` - Build VM image directly
- `vagrant up` - Create VMs from existing box
- `ansible-playbook vagrant-playbook.yml` - Run main provisioning playbook

## Architecture

### Build Pipeline
1. **Packer Phase**: Creates hardened RHEL8 base image using `rhel8.pkr.hcl`
   - Uses kickstart automation via `kickstart/ks.cfg`
   - Applies STIG hardening through `packer-playbook.yml`
   - Outputs Vagrant box to `output-rhel8/`

2. **Vagrant Phase**: Provisions VMs from base image
   - Creates multi-node AAP cluster (controller, hub, database)
   - Uses `vagrant-playbook.yml` for full AAP deployment

### Key Playbooks
- `vagrant-playbook.yml` - Main provisioning playbook for complete AAP deployment
- `stig-playbook.yml` - STIG compliance hardening
- `packer-playbook.yml` - Image preparation during Packer build

### Infrastructure Layout
- `192.168.56.11` - Automation Controller (primary) and Database
- `192.168.56.12` - Automation Hub
- `192.168.56.13` - Additional node

### Role Structure
- `roles/RHEL8_STIG/` - DISA STIG compliance implementation
- `roles/aap/` - Ansible Automation Platform installation
- `roles/dvd_repository/` - RHEL ISO repository configuration
- `roles/ssh_keys/` - SSH key management for cluster nodes

### Configuration Management
- `group_vars/controller/` - AAP controller configuration (credentials, projects, job templates)
- `inventory/` - Ansible inventory definitions
- `ansible.cfg` - Ansible configuration with custom callbacks and settings

## Development Notes

The codebase follows a infrastructure-as-code approach where VM provisioning is fully automated. The STIG role provides comprehensive security hardening based on DISA requirements. AAP deployment is configured through the controller configuration collection for post-installation setup.
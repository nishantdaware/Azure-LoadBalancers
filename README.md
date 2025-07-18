
---

## 🚀 Overview

This Terraform project provisions the following resources in Azure:

- **Virtual Machines**
  - Supports provisioning of both Linux and Windows VMs
  - NICs, IPs, and OS configuration handled per instance
- **Load Balancers**
  - Azure Standard Load Balancer with frontend and backend pool configurations
  - Health probes and NAT rules for VM access
- **Networking**
  - Subnet and network interface definitions
- **Infrastructure Configuration**
  - Use of locals for reusable configuration blocks
  - Variables for environment flexibility (region, tags, VM size, etc.)

---

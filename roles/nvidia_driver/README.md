# nvidia_driver

Installs the NVIDIA server driver from Ubuntu's repos so the host GPU can be used for compute.

## Requirements
- Ubuntu 24.04 (noble) on the host.
- A Turing or newer GPU when using an open kernel module driver package.

## What it does
1. Installs the kernel headers, `dkms` and the driver package in `nvidia_driver_package`.
2. Reboots the host if anything was installed, so the driver is loaded before the roles that follow.

## Variables
| Variable | Default | Purpose |
|---|---|---|
| `nvidia_driver_package` | `nvidia-driver-615-server-open` | Driver package to install |

Every variable is listed in `meta/argument_specs.yml`.

## Notes
- 615 is the newest branch available for noble and ships open kernel modules only. Older branches are
  metapackages that redirect upward (570 -> 580, 590 -> 595, 610 -> 615).
- The reboot only happens when the package install changes something.

# nvidia_container_toolkit

Installs the [NVIDIA container toolkit](https://github.com/NVIDIA/nvidia-container-toolkit) and
configures Docker to use it, so containers can reserve the GPU.

## Requirements
- Ubuntu 24.04 (noble) on the host.
- The NVIDIA driver (see `nvidia_driver`) and Docker already installed.

## What it does
1. Adds NVIDIA's apt repository.
2. Installs `nvidia-container-toolkit`.
3. Runs `nvidia-ctk runtime configure --runtime=docker` and restarts Docker.

## Variables
| Variable | Default | Purpose |
|---|---|---|
| `nvidia_container_toolkit_repo_uri` | `https://nvidia.github.io/libnvidia-container/stable/deb/amd64` | Apt repository URI |
| `nvidia_container_toolkit_repo_key` | `https://nvidia.github.io/libnvidia-container/gpgkey` | Repository signing key |

Every variable is listed in `meta/argument_specs.yml`.

## Notes
- Docker is restarted on every run, which restarts running containers.

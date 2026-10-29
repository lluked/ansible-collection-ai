# nvidia_gpu_check

Checks that the GPU is visible on the host and inside a container, and reports what it finds.

## Requirements
- The NVIDIA driver and container toolkit on the host (see `nvidia_driver` and `nvidia_container_toolkit`).
- Docker on the host.

## What it does
1. Runs `nvidia-smi` on the host, retrying for up to a minute while the driver comes up.
2. Runs `nvidia-smi -L` in a throwaway container with all GPUs.
3. Prints both results.

## Variables
| Variable | Default | Purpose |
|---|---|---|
| `nvidia_gpu_check_image` | `ubuntu:24.04` | Image the container check runs in |

Every variable is listed in `meta/argument_specs.yml`.

## Notes
- The role changes nothing; it fails if either check does.

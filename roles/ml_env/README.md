# ml_env

Runs a fine-tuning and distillation environment in Docker: JupyterLab with PyTorch (CUDA),
transformers, peft, trl, bitsandbytes and related libraries, with GPU access.

## Requirements
- Docker and the NVIDIA container toolkit on the host.
- Internet access for the PyTorch wheels and Python packages when the image builds.
- `community.docker` collection.

## What it does
1. Creates the shared Docker network and the `work` and `huggingface` data directories.
2. Writes a Dockerfile and builds the image. The tag is a hash of the package list and PyTorch index,
   so it rebuilds only when those change.
3. Generates a 40-character JupyterLab token on the first run and stores it in `ml_env_token_file`
   (mode `0600`). Later runs reuse it.
4. Starts the `ml-env` container with all GPUs reserved and waits for JupyterLab.
5. Fails if `torch.cuda.is_available()` is false inside the container, and prints the PyTorch
   version and GPU name.

## Variables
| Variable | Default | Purpose |
|---|---|---|
| `ml_env_packages` | transformers, datasets, accelerate, peft, trl, bitsandbytes, ... | Python packages |
| `ml_env_port` | `8888` | Host port for JupyterLab |
| `ml_env_external_access` | `ai_tools_external_access`, else `true` | Publish the port on the host; overrides the global for this role |
| `ml_env_bind_address` | `127.0.0.1` | Host address the port binds to when external access is on; `0.0.0.0` serves the LAN |
| `ml_env_data_dir` | `/srv/ai/ml-env-data` | `work` (notebooks) and `huggingface` (model cache) |
| `ml_env_token_file` | `/srv/ai/ml-env-token` | Where the token is kept |
| `ml_env_shm_size` | `8g` | Shared memory for data loader workers |
| `ml_env_torch_package_index` | cu128 wheels | PyTorch index |
| `ml_env_uid` / `ml_env_gid` | `1000` | User the container runs as |

Every variable is listed in `meta/argument_specs.yml`.

## Using it
- The port is published on the host's `127.0.0.1:8888` by default. Open `http://localhost:8888` on the
  host (or through a tunnel, below) and enter the token: `sudo cat /srv/ai/ml-env-token`.
- Notebooks and scripts in `/work` are kept in `<ml_env_data_dir>/work`.
- Downloaded models and datasets are cached in `<ml_env_data_dir>/huggingface`, so they survive
  rebuilds.
- For a shell instead of a notebook: `docker exec -it ml-env bash`.

### Accessing it from another machine
JupyterLab is bound to the host's loopback by default, so reach it through an SSH tunnel.

1. From your own machine, open a tunnel:
   ```
   ssh -N -L 8888:localhost:8888 <user>@<host>
   ```
   This forwards port 8888 on your machine to port 8888 on the host. `-N` opens the tunnel without a
   shell, and `-f` backgrounds it. If 8888 is already in use locally, change the first number, for
   example `-L 9999:localhost:8888`.
2. Browse to `http://localhost:8888` and enter the token from
   `ssh <user>@<host> sudo cat /srv/ai/ml-env-token`. Closing the ssh session closes the tunnel.

To open the tunnel with a plain `ssh -N ai-host`, add this to `~/.ssh/config`:
```
Host ai-host
  HostName <host>
  User <user>
  LocalForward 8888 localhost:8888
```

To serve the LAN instead, set `ml_env_bind_address: 0.0.0.0`. To publish nothing, set
`ml_env_external_access: false` (or `ai_tools_external_access: false` for all tools).

## Notes
- Anyone with the token can run code in the container, so keep the port on localhost or a network you
  trust.
- The container is a service and stays running. It only holds VRAM while a notebook is using it.

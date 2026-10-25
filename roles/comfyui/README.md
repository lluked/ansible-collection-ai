# comfyui

Runs [ComfyUI](https://github.com/comfyanonymous/ComfyUI) in Docker for image generation. Upstream
publishes no image, so the role builds one from a pinned commit and downloads the models you list.

## Requirements
- Docker and the NVIDIA container toolkit on the host.
- Internet access for the PyTorch wheels, the ComfyUI source and the model downloads.
- `community.docker` collection.

## What it does
1. Creates the shared Docker network and the data directories.
2. Downloads each entry in `comfyui_models` into the data directory (verified by checksum when given).
3. Writes a Dockerfile and builds the image, tagged with the first 12 characters of `comfyui_ref`.
4. Starts the `comfyui` container as `comfyui_uid:comfyui_gid` with all GPUs reserved, then waits
   for `/system_stats`.

`models`, `input`, `output`, `user` and `custom_nodes` are mounted from the data directory, so they
survive rebuilds.

## Variables
| Variable | Default | Purpose |
|---|---|---|
| `comfyui_ref` | pinned commit | Upstream commit to build; change it to update ComfyUI |
| `comfyui_models` | SDXL base 1.0 | Downloads: `name`, `url`, `dest` (under the data directory), optional `checksum` |
| `comfyui_port` | `8188` | Host port |
| `comfyui_external_access` | `ai_backends_external_access`, else `true` | Publish the port on the host; overrides the global for this role |
| `comfyui_bind_address` | `127.0.0.1` | Host address the port binds to when external access is on; `0.0.0.0` serves the LAN |
| `comfyui_data_dir` | `/srv/ai/comfyui-data` | Models, inputs, outputs and workflows |
| `comfyui_torch_package_index` | cu128 wheels | PyTorch index |
| `comfyui_uid` / `comfyui_gid` | `1000` | User the container runs as |

Every variable is listed in `meta/argument_specs.yml`.

## Using it
Containers on the network reach it at `http://comfyui:8188`. The `open_webui` role points its image
generation at that URL.

The port is also published on the host's `127.0.0.1:8188` (`comfyui_external_access` is on by default),
so open `http://localhost:8188` on the host. From another machine, tunnel with
`ssh -N -L 8188:localhost:8188 <user>@<host>`, or set `comfyui_bind_address: 0.0.0.0` for the LAN. Set
`comfyui_external_access: false` (or `ai_backends_external_access: false` for all backends) to publish
nothing.

## Notes
- The first run builds the image and downloads PyTorch, which takes several minutes.
- Add checkpoints to `comfyui_models` (`dest: models/checkpoints/<file>`), LoRAs under
  `models/loras/`, and so on.

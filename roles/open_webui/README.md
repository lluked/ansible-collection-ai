# open_webui

Runs [Open WebUI](https://openwebui.com) in Docker as the chat and image front end for the other
services on the network.

## Requirements
- Docker on the host.
- `community.docker` collection.
- Optional: the `ollama`, `strata` and `comfyui` roles, which it connects to by container name.

## What it does
1. Creates the shared Docker network, the data directory and the compose directory.
2. If the Strata key file exists, reads it so Strata can be added as an OpenAI-compatible connection.
3. Writes the compose file (mode `0600`, since it can hold the key) and starts the container.

The container is configured with:
- the Ollama URL,
- the Strata URL and key (only when the key file exists),
- image generation through ComfyUI, using Open WebUI's built-in text-to-image workflow and the node
  mapping in `open_webui_comfyui_nodes`.

## Variables
| Variable | Default | Purpose |
|---|---|---|
| `open_webui_port` | `3000` | Host port |
| `open_webui_external_access` | `ai_clients_external_access`, else `true` | Publish the port on the host; overrides the global for this role |
| `open_webui_bind_address` | `127.0.0.1` | Host address the port binds to when external access is on; `0.0.0.0` serves the LAN |
| `open_webui_ollama_url` | `http://ollama:11434` | Ollama API |
| `open_webui_strata_url` | `http://strata:8080/v1` | Strata API |
| `open_webui_strata_api_key_file` | `/srv/ai/strata-api-key` | Strata key; connection skipped if missing |
| `open_webui_comfyui_url` | `http://comfyui:8188` | ComfyUI for images |
| `open_webui_image_model` | `sd_xl_base_1.0.safetensors` | Checkpoint used for images |
| `open_webui_image_size` / `open_webui_image_steps` | `1024x1024` / `30` | Image settings |
| `open_webui_comfyui_nodes` | node mapping | Request fields to node ids in the workflow |

Every variable is listed in `meta/argument_specs.yml`.

## Using it
The port is published on the host's `127.0.0.1:3000` by default. From another machine, tunnel with
`ssh -N -L 3000:localhost:3000 <user>@<host>`, or set `open_webui_bind_address: 0.0.0.0` to serve the
LAN. Set `open_webui_external_access: false` (or `ai_clients_external_access: false` for all clients)
to publish nothing. Open `http://localhost:3000`. The first account you create becomes the admin, so
create it before anyone else who can reach the port does. Chat with a model, then use the image toggle or the image icon
under a reply to generate pictures.

## Notes
- Open WebUI stores its settings in its database on the first start. After that, the environment
  variables above are ignored. To change a connection or the image settings on an existing install,
  use Admin → Settings in the UI.
- If the Strata key file does not exist when the role runs, the Strata connection is left out. Run
  the role again after `strata`.

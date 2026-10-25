# strata

Runs the [Strata](https://github.com/Niko1221/Strata) LLM engine from its prebuilt upstream image.
It serves an OpenAI-compatible API at `/v1` and loads its model on the GPU.

## Requirements
- Docker and the NVIDIA container toolkit, with driver 580 or newer for the default CUDA 13 image.
- At least 32 GB of RAM plus VRAM combined. The default `IQ3_XXS` model needs about 48 GB.
- `community.docker` collection.

## What it does
1. Creates the shared Docker network and pulls the image.
2. Generates a 40-character API key on the first run and stores it in `strata_api_key_file`
   (mode `0600`). Later runs reuse it.
3. Writes the compose file with the model and key, and starts the `strata` container.
4. Waits for the port. The first start downloads the model (tens of GB), so this can take a long time.

## Variables
| Variable | Default | Purpose |
|---|---|---|
| `strata_image` | `ghcr.io/niko1221/strata:0.2.3-cuda13` | Prebuilt image |
| `strata_model` | `IQ3_XXS` | Model size or quant; pick a smaller one on less memory |
| `strata_port` | `8080` | Host port |
| `strata_external_access` | `ai_backends_external_access`, else `false` | Publish the port on the host; overrides the global for this role |
| `strata_bind_address` | `127.0.0.1` | Host address the port binds to when external access is on; `0.0.0.0` serves the LAN |
| `strata_api_key_file` | `/srv/ai/strata-api-key` | Where the key is kept |
| `strata_volume` | `strata-data` | Docker volume for models and state |

Every variable is listed in `meta/argument_specs.yml`.

## Using it
- Containers on the network: `http://strata:8080/v1`, with the key as the bearer token.
- No port is published on the host by default. To call it from the host or another machine, set
  `strata_external_access: true` (or `ai_backends_external_access: true` for all backends). The port
  then binds to `strata_bind_address` (`127.0.0.1`), so tunnel with
  `ssh -N -L 8080:localhost:8080 <user>@<host>`, or set the address to `0.0.0.0` for the LAN.
- Read the key on the host with `sudo cat /srv/ai/strata-api-key`.
- The `open_webui` role reads the same key file and adds the connection to Open WebUI.

## Notes
- Removing the container keeps the `strata-data` volume. Remove the volume to free the downloaded
  model: `docker volume rm strata_strata-data`.

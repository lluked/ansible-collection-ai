# ollama

Runs [Ollama](https://ollama.com) in Docker with GPU access and pulls the models you list. Here it
serves the embedding model for RAG and a small chat model.

## Requirements
- Docker and the NVIDIA container toolkit on the host.
- `community.docker` collection.

## What it does
1. Creates the shared Docker network, the data directory and the compose directory.
2. Writes the compose file and starts the `ollama` container with all GPUs reserved.
3. Waits for the API, then pulls every model in `ollama_models` that is not installed yet.
   Models that are not listed are left alone.

## Variables
| Variable | Default | Purpose |
|---|---|---|
| `ollama_models` | `qwen3.5:4b`, `nomic-embed-text` | Models to pull |
| `ollama_port` | `11434` | Host port |
| `ollama_external_access` | `ai_backends_external_access`, else `false` | Publish the port on the host; overrides the global for this role |
| `ollama_bind_address` | `127.0.0.1` | Host address the port binds to when external access is on; `0.0.0.0` serves the LAN |
| `ollama_context_length` | `16384` | Context window; larger uses more VRAM |
| `ollama_keep_alive` | `30m` | How long a model stays loaded after its last request |
| `ollama_data_dir` | `/srv/ai/ollama` | Model storage |
| `ollama_network` | `ai` | Shared Docker network |

Every variable is listed in `meta/argument_specs.yml`. `ai_root` and `ai_network` change the shared
defaults for all roles.

## Using it
Other containers on the network reach it at `http://ollama:11434`. No port is published on the host
by default. To use it from the host or another machine, set `ollama_external_access: true` (or
`ai_backends_external_access: true` for all backends). The port then binds to `ollama_bind_address`
(`127.0.0.1`), so tunnel from another machine with `ssh -N -L 11434:localhost:11434 <user>@<host>`, or
set the address to `0.0.0.0` for the LAN.

## Notes
- Use the same embedding model to ingest and to query documents.
- A loaded model holds VRAM until `ollama_keep_alive` expires.

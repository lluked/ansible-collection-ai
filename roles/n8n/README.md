# n8n

Runs [n8n](https://n8n.io) workflow automation in Docker, on the same network as Ollama and Qdrant
so workflows can use them for AI and RAG.

## Requirements
- Docker on the host.
- `community.docker` collection.

## What it does
1. Creates the shared Docker network, the data directory (owned by uid 1000, as the image requires)
   and the compose directory.
2. Writes the compose file and starts the `n8n` container.
3. Waits for `/healthz`.

## Variables
| Variable | Default | Purpose |
|---|---|---|
| `n8n_image` | `docker.n8n.io/n8nio/n8n:latest` | Container image |
| `n8n_port` | `5678` | Host port |
| `n8n_external_access` | `ai_clients_external_access`, else `true` | Publish the port on the host; overrides the global for this role |
| `n8n_bind_address` | `127.0.0.1` | Host address the port binds to when external access is on; `0.0.0.0` serves the LAN |
| `n8n_timezone` | `Europe/London` | Schedules and logs |
| `n8n_secure_cookie` | `false` | Set to `true` behind HTTPS |
| `n8n_ollama_url` | `http://ollama:11434` | Value for the Ollama credential |
| `n8n_qdrant_url` | `http://qdrant:6333` | Value for the Qdrant credential |
| `n8n_data_dir` | `/srv/ai/n8n` | Workflows and credentials |

Every variable is listed in `meta/argument_specs.yml`.

## Using it
The port is published on the host's `127.0.0.1:5678` by default. From another machine, tunnel with
`ssh -N -L 5678:localhost:5678 <user>@<host>`, or set `n8n_bind_address: 0.0.0.0` to serve the LAN.
Set `n8n_external_access: false` (or `ai_clients_external_access: false` for all clients) to publish
nothing. Open `http://localhost:5678`. In n8n, create:
- an **Ollama** credential with `n8n_ollama_url`, for the chat and embeddings nodes;
- a **Qdrant** credential with `n8n_qdrant_url` and no API key, for the vector store nodes.

## Notes
- The secure cookie is off because the login is plain HTTP. Turn it on if you add TLS, or the
  login fails.
- `n8n_ollama_url` and `n8n_qdrant_url` are only values to copy into credentials. The role does not
  create the credentials.

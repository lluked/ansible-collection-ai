# qdrant

Runs the [Qdrant](https://qdrant.tech) vector database in Docker. It stores the embeddings for RAG
workflows in n8n.

## Requirements
- Docker on the host.
- `community.docker` collection.

## What it does
1. Creates the shared Docker network, the data directory and the compose directory.
2. Writes the compose file and starts the `qdrant` container.
3. Waits for `/healthz` to answer.

## Variables
| Variable | Default | Purpose |
|---|---|---|
| `qdrant_image` | `qdrant/qdrant:latest` | Container image |
| `qdrant_port` | `6333` | Host port for the REST API |
| `qdrant_external_access` | `ai_backends_external_access`, else `true` | Publish the port on the host; overrides the global for this role |
| `qdrant_bind_address` | `127.0.0.1` | Host address the port binds to when external access is on; `0.0.0.0` serves the LAN |
| `qdrant_data_dir` | `/srv/ai/qdrant` | Stored collections |
| `qdrant_network` | `ai` | Shared Docker network |

Every variable is listed in `meta/argument_specs.yml`.

## Using it
Containers on the network reach it at `http://qdrant:6333`. In n8n, create a Qdrant credential with
that URL and no API key.

The port is also published on the host's `127.0.0.1:6333` (`qdrant_external_access` is on by default),
so the dashboard is at `http://localhost:6333/dashboard` on the host. From another machine, tunnel with
`ssh -N -L 6333:localhost:6333 <user>@<host>`. Set `qdrant_external_access: false` (or
`ai_backends_external_access: false` for all backends) to publish nothing.

## Notes
- Authentication is not enabled, so the port is bound to localhost. Tunnel to it from another machine
  rather than setting `qdrant_bind_address` to `0.0.0.0`, which opens it to the whole LAN.

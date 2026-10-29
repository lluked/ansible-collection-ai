# lluked.ai

Roles for running AI services on a host. Each role installs everything it needs, so any of them can run
on its own on a host that already has Docker (and the NVIDIA container toolkit for the GPU roles). The Docker roles
join a shared `ai` network, so they reach each other by container name.

## Host

GPU setup for the host itself, run before the Docker roles.

| Role | Provides |
|---|---|
| nvidia_driver | NVIDIA server driver from Ubuntu's repos, rebooting when it changes |
| nvidia_container_toolkit | NVIDIA container toolkit from NVIDIA's apt repo, configured as a Docker runtime |
| nvidia_gpu_check | Checks the GPU is visible on the host and inside a container, and reports it |

## Backends

Services that serve models or store data. Other containers reach them by name over the `ai` network.
Whether a role also publishes its port on the host is set by its `<role>_external_access` variable
(on for `qdrant` and `comfyui`, off for `ollama` and `strata`, unless the global below is set). When it is on, the port binds to the
role's `<role>_bind_address`, which defaults to `127.0.0.1`.

The shared variable `ai_backends_external_access` sets the default for all four: `true` publishes them
all, `false` publishes none. A `<role>_external_access` you set explicitly wins over it for that role.

| Role | Provides | Authentication | External Access (Default) |
|---|---|---|---|
| ollama | Ollama in Docker with the base models pulled | None | Off |
| qdrant | Qdrant vector store in Docker, for RAG | None | Localhost Only |
| strata | Strata LLM engine from the upstream image | API key (generated) | Off |
| comfyui | ComfyUI in Docker (built from a pinned upstream ref) for image generation | None | Localhost Only |

## Clients

Services that use the backends over the `ai` network and that you open in a browser.

Like the backends, each client publishes its port on the host only when its `<role>_external_access`
is on (the default), bound to its `<role>_bind_address` (`127.0.0.1`). The shared variable
`ai_clients_external_access` sets the default for both, and a role's own setting wins over it. Set
`<role>_bind_address: 0.0.0.0` to serve the LAN.

| Role | Provides | Authentication | External Access (Default) |
|---|---|---|---|
| open_webui | Open WebUI in Docker: chat with Ollama and Strata, images through ComfyUI | First user becomes admin | Localhost Only |
| n8n | n8n workflow automation in Docker, on the same network as the backends | First user becomes owner | Localhost Only |

## Tools

Development tooling for working on models.

Like the clients, a tool publishes its port on the host only when its `<role>_external_access` is on
(the default), bound to its `<role>_bind_address` (`127.0.0.1`). The shared variable
`ai_tools_external_access` sets the default for all tools, and a role's own setting wins over it. Set
`<role>_bind_address: 0.0.0.0` to serve the LAN.

| Role | Provides | Authentication | External Access (Default) |
|---|---|---|---|
| ml_env | Fine-tuning environment in Docker: JupyterLab with PyTorch, transformers, peft, trl | Token (generated) | Localhost Only |

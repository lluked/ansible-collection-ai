# Changelog

## 1.1.2

- Fix the `strata` role failing on a host where the API key directory (`/srv/ai` by default) does not exist yet. The role now creates it before generating the key.

## 1.1.1

- Add the missing README and metadata to the NVIDIA roles, which Galaxy requires to import.
- Add a pre-commit hook that runs the Galaxy import check.

## 1.1.0

- Add the `nvidia_driver`, `nvidia_container_toolkit` and `nvidia_gpu_check` roles.

## 1.0.0

- Initial commit.

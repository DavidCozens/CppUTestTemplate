# Container Images

## Images in use

| Image | Tag | Used by |
|---|---|---|
| `davidcozens/cpputest` | `sha-d8df77c` | devcontainer (`dev` service), all CI jobs except clang |
| `davidcozens/cpputest-clang` | `sha-ddaf55d` | `clang` compose service, `clang-build-and-test` CI job |

## Docker Compose setup

The devcontainer uses Docker Compose (`.devcontainer/docker-compose.yml`).
VS Code connects to the `dev` service (GCC). The `clang` service is on-demand only —
it starts when you explicitly run a command against it and stops when done.

As cross-compilation targets are added, each gets its own service in the compose file,
following the same pattern.

## Running the clang build locally

From a host terminal (not inside the devcontainer):

```bash
docker compose -f .devcontainer/docker-compose.yml run --rm clang \
    cmake --preset clang-debug

docker compose -f .devcontainer/docker-compose.yml run --rm clang \
    cmake --build --preset clang-debug --target junit
```

## Updating an image

When a new image tag is available:

1. Build and push the new image in the container image repo
2. Update the SHA tag in `.devcontainer/docker-compose.yml` and `.github/workflows/ci.yml` together
3. Rebuild the devcontainer (`Ctrl+Shift+P` → "Dev Containers: Rebuild Container") and verify locally
4. Raise a PR — use `chore: bump container image to <sha>` as the title

Both files must always reference the same tag. Never update one without the other.

## Debugging a Clang or cross-compiler issue directly

If you need to work interactively in the clang (or other) container, temporarily update
the `service` in `.devcontainer/devcontainer.json` from `dev` to `clang` (or the relevant service)
and rebuild. Revert when done.

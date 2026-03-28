# Container Images

## Images in use

| Image | Tag | Used by |
|---|---|---|
| `ghcr.io/davidcozens/cpputest` | `sha-e7aa8a1` | devcontainer (`gcc` service), all CI jobs except clang |
| `ghcr.io/davidcozens/cpputest-clang` | `sha-6ea3f95` | `clang` compose service, `clang-build-and-test` CI job |

## Docker Compose setup

The devcontainer uses Docker Compose (`.devcontainer/docker-compose.yml`).
VS Code connects to the `gcc` service (GCC). The `clang` service is on-demand only —
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

1. Build and push the new image to GHCR (`ghcr.io/davidcozens/cpputest` or `ghcr.io/davidcozens/cpputest-clang`)
2. Update the SHA tag in `.devcontainer/docker-compose.yml`, `.github/workflows/ci.yml`, and `docs/containers.md` together
3. Rebuild the devcontainer (`Ctrl+Shift+P` → "Dev Containers: Rebuild Container") and verify locally
4. Raise a PR — use `chore: bump container image to <sha>` as the title

All three files must always reference the same tag. Never update one without the others.

## Switching to a different container as the devcontainer

Each service in `docker-compose.yml` sets a `BUILD_PRESET` environment variable that
VS Code tasks pick up automatically. This means a single change — the `service` in
`.devcontainer/devcontainer.json` — is all that is needed to switch environments.
Ctrl+Shift+B and all other tasks will use the correct preset for that container.

To work interactively in the clang container (e.g. to debug a Clang-specific issue):

1. In `.devcontainer/devcontainer.json`, change `"service": "gcc"` to `"service": "clang"`
2. Rebuild the devcontainer (`Ctrl+Shift+P` → "Dev Containers: Rebuild Container")
3. Work normally — Ctrl+Shift+B will build with `clang-debug`

When done, revert `"service"` back to `"gcc"` and rebuild again.

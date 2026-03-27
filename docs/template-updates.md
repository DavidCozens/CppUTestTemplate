# Pulling Template Updates into a Clone

When this template is updated (e.g. a new cross-compiler service, a CI hardening change,
a new CMake preset), those changes can be merged into any clone using Git's standard
remote merge workflow.

## One-time setup on a clone

Add the template as a named remote:

```bash
git remote add template git@github.com:DavidCozens/CppUTestTemplate.git
git fetch template
```

## Pulling an update

```bash
git fetch template
git merge template/main
```

Resolve any conflicts (see below), then raise a PR as normal.

## What typically conflicts

| File | Why | Resolution |
|---|---|---|
| `.release-please-manifest.json` | Version number diverges in the clone | Always keep the clone's version |
| `README.md` | Title and description are project-specific | Keep the clone's content |

## What should NOT be edited in clones

These files are owned by the template. Avoid modifying them in clones so that
template merges apply cleanly:

- `.devcontainer/docker-compose.yml`
- `.github/workflows/ci.yml`
- `.github/workflows/release-please.yml`
- `CMakePresets.json`
- `Source/CMakeLists.txt`
- `Tests/CMakeLists.txt`
- `.clang-format`
- `.clang-tidy`
- `docs/` (all files)

If a change is needed to these files in a clone, consider whether it belongs in
the template first and should be merged back.

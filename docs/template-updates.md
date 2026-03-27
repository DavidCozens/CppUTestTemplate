# Creating and Maintaining a Clone

## Creating a new component repository

### 1. Create a new repository on GitHub

Create an empty repository on GitHub for your component (e.g. `LedDriver`).
Do not initialise it with a README or any other files.

### 2. Clone the template

```bash
git clone git@github.com:DavidCozens/CppUTestTemplate.git LedDriver
cd LedDriver
```

### 3. Point the origin remote at the new repository

```bash
git remote set-url origin git@github.com:DavidCozens/LedDriver.git
```

### 4. Add the template as a named remote

This allows template updates to be pulled in later:

```bash
git remote add template git@github.com:DavidCozens/CppUTestTemplate.git
```

Verify your remotes:

```bash
git remote -v
# origin    git@github.com:DavidCozens/LedDriver.git (fetch)
# origin    git@github.com:DavidCozens/LedDriver.git (push)
# template  git@github.com:DavidCozens/CppUTestTemplate.git (fetch)
# template  git@github.com:DavidCozens/CppUTestTemplate.git (push)
```

### 5. Push to the new repository

```bash
git push -u origin main
```

### 6. Run the init script

```bash
bash scripts/init-component.sh LedDriver
```

This will:
- Rename the CMake project to `LedDriver`
- Replace the example source, header, and test files with a `LedDriver` stub
- Update the VS Code debugger launch configuration
- Update the README title

### 7. Build and verify the red bar

```bash
cmake --preset debug
cmake --build --preset debug --target junit
```

Expect exactly one failing test (`LedDriver.NeedsWork`). This confirms the build
and test harness are working. Begin TDD from here.

### 8. Configure branch protection on the new repository

In the GitHub repository settings, configure branch protection on `main`:
- Require a pull request before merging
- Require all status checks to pass: `build-and-test`, `clang-build-and-test`, `sanitize`, `coverage`, `tidy`, `cppcheck`, `format`
- Require squash merge only
- Enable automatic branch deletion after merge

### 9. Commit and push the initialised project

```bash
git add -A
git commit -m "feat: initialise LedDriver component"
git push
```

---

## Pulling template updates into a clone

When the template is updated (e.g. a new cross-compiler service, a CI hardening change,
a new CMake preset), pull those changes into any clone:

```bash
git fetch template
git merge template/main
```

Resolve any conflicts (see below), then raise a PR as normal.

### What typically conflicts

| File | Why | Resolution |
|---|---|---|
| `.release-please-manifest.json` | Version number diverges in the clone | Always keep the clone's version |
| `README.md` | Title and description are project-specific | Keep the clone's content |

### What should NOT be edited in clones

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

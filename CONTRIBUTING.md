# Contributing

## Scope

JorisHoef Selection Suite is a curated UPM bundle. Keep runtime behavior in the underlying packages:

- Core State for repositories and data selection.
- Object Selection for world-object selection.
- Generic UI Items for data-driven UI item rendering.
- Bridge packages for synchronization through shared keys.

Do not add a 3-way bridge to this package. Add runtime behavior to the package that owns that behavior, or to an explicit bridge package when two packages need integration.

## Local Validation

Run structural validation from the package root:

```powershell
pwsh ./Tools/Validate-Package.ps1
```

For Unity validation, use a separate test project that references this package by file path:

```json
"com.jorishoef.selection-suite": "file:C:/Repositories/JorisHoef.Selection-Suite"
```

## Pull Requests

- Prefer documentation and samples over runtime code.
- Keep sample code isolated under `Samples~`.
- Keep dependencies aligned with the package registry.
- Do not add Unity project scaffolding such as `Assets`, `Packages`, or `ProjectSettings` to this repository.

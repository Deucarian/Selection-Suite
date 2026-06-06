# Selection Suite

JorisHoef Selection Suite is a curated package that installs the reusable selection stack.

It does not introduce a new runtime selection API. The package graph stays explicit:

```text
ObjectSelection
  |
  v
ObjectSelection-CoreState Bridge
  |
  v
CoreState
  |
  v
GenericUIItems-CoreState Bridge
  |
  v
GenericUIItems
```

## Ownership

- ObjectSelection owns world-object selection state, raycast selection, and world highlighting hooks.
- CoreState owns repositories and application/data selection state.
- GenericUIItems owns rendering data collections into UI items.
- ObjectSelection-CoreState Bridge synchronizes world selection with CoreState selection.
- GenericUIItems-CoreState Bridge synchronizes CoreState repositories and selection into GenericUIItems containers.

## Samples

Import `Selection Demo` from Unity Package Manager. The sample builds its primitives and UGUI layout at runtime so it can stay self-contained inside the package.

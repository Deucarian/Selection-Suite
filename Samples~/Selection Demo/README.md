# Selection Demo

Open `SelectionSuiteDemo.unity` and enter Play Mode.

The sample creates four world primitives with matching CoreState data items:

- `cube`
- `sphere`
- `capsule`
- `cylinder`

Click a world object to select it through ObjectSelection. The ObjectSelection-CoreState bridge updates CoreState, and the GenericUIItems-CoreState bridge updates the UI list selected state.

Click a UI list item to select it through CoreState. The ObjectSelection-CoreState bridge updates ObjectSelection, and the sample highlighter updates the world object.

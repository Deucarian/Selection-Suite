# Selection Demo

Open `SelectionSuiteDemo.unity` and enter Play Mode.

The sample creates four world primitives with matching CoreState data items:

- `cube`
- `sphere`
- `capsule`
- `cylinder`

Click a world object to select it through ObjectSelection. The ObjectSelection-CoreState integration updates CoreState, and the UIBinding-CoreState integration updates the UI list selected key. The UI list uses sample-only row tinting for selected and normal rows.

Click a UI list item to select it through CoreState. The ObjectSelection-CoreState integration updates ObjectSelection, and an ObjectSelection visual controller applies a simple tint and scale visual to the selected world object while restoring the previous object.

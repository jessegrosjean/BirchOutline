# Birch Outline (Swift)

Birch Outline is a Swift framework (iOS & macOS) that wraps [birch-outline](https://github.com/jessegrosjean/birch-outline).

It's in pre-release now, but I think it's suitable for reading, processing, and seriaizing TaskPaper outlines. In the future the wrapper can be extended to serve as a good runtime outline model for other apps to build off.

## Example

```swift
import BirchOutline

let outline = Birch.createTaskPaperOutline("one:")
let one = outline.root.firstChild

let two = outline.createItem("two")
two.setAttribute("data-type", value: "task")
two.setAttribute("data-priority", value: "1")
one.appendChildren([two])

let three = outline.createItem("three")
two.appendChild([three])

print(outline.serialize(nil))

/*
one:
  - two @priority(1)
    three
*/
```

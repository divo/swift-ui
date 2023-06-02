# Intro

Swift UI is pretty different from UIKit or other UI frameworks. Views are values, not objects and are expressed declaratively. It also has it's own layout system (Oh great, another iOS layout system).

# Overview
To construct views in SwiftUI, you create a tree of view values that describe what should be onscreen. To change what’s onscreen, you modify state, and a new tree of view values is computed. SwiftUI then updates the screen to reflect these new view values.

Modifying the properties of a View will not update the UI. Instead we must update the views _state_. The state is declated with an `@State` modifier inside the view.

SwiftUI IDE integration seems pretty nice. You can live preview the View, update properties of subviews and the code will be updated automatically. Neato.

Swift uses a View Builder, a type of function builder, to figure out the different possible permutations of your views ahead of time. The catch is you can only use a limited subset of Swift inside a view builder. Conditionals are ok, loops are not (This book is from 2020 though, more features may have been added since)

Each modifier (background, cornerRadius etc) adds a new node to the view tree. This means modifiers effectivly stack and do not apply to previous elements in the tree, e.x. `.padding().background()` and `.background().padding()` will look different. The former will have the background extend with the padding, the latter will not set the background color of the padding.

## View layout primer
(This will get a full chapter later)

View layout happens recursively. The system gives the top level view the entire screen size, and it passes this size to all it's children. This continues to the bottom of the view tree where each element then passes the size it needs back up the tree. Each level in the tree takes on the size of it's children. The key difference to UIKit is we never set properties on a view, we attach modifiers. So `.frame(200, 200)` isn't setting the frame of a View, it's wrapping it in a modifier that gets applied during layout. This means the order modifiers are applied in matters.

# RegexTemplates

This package makes it possible to efficiently replace a regular expression with a template containing `$1`, `S2`, etc.

Example:

```swift
// converting to a new text:
print(#replacingWithTemplate(in: "123 hello!", replace: /([a-z]+)/, withTemplate: "$1 $1"))
// prints "123 hello hello!"

// changing a given text:
var changingText = "123 hello!"
#replaceWithTemplate(in: changingText, replace: /([a-z]+)/, withTemplate: "$1 $1")
print(changingText) // prints "123 hello hello!")
```

Example with matching semantics `.unicodeScalar`:

```swift
// converting to a new text:
print(#replacingWithTemplate(in: "a\u{0307}", replace: /([a-z])\x{0307}/.matchingSemantics(.unicodeScalar), withTemplate: "$1\u{0300}"))
// prints "à"

// changing a given text:
var changingText = "a\u{0307}"
#replaceWithTemplate(in: changingText, replace: /([a-z])\x{0307}/.matchingSemantics(.unicodeScalar), withTemplate: "$1\u{0300}")
print(changingText) // prints "à"
```

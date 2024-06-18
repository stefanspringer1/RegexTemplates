# RegexTemplates

This package makes it possible to efficiently replace a regular expression with a template containing `$1`, `S2`, etc.

Example:

```swift
print(#replaceWithTemplate(in: "123 hello!", replace: /([a-z]+)/, withTemplate: "$1 $1"))
// prints "123 hello hello!"
```

Example with matching semantics `.unicodeScalar`:

```swift
print(#replaceWithTemplate(in: "a\u{0307}", replace: /([a-z])\x{0307}/.matchingSemantics(.unicodeScalar), withTemplate: "$1\u{0300}"))
// prints "à"
```

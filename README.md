# RegexTemplates

This packages makes it possible to efficiently replace regular expression with template containing `$1`, `S2`, etc.

Example:

```swift
print(#replaceWithTemplate(in: "123 hello!", replace: /([a-z]+)/, withTemplate: "$1 $1"))
// prints "123 hello hello!"
```

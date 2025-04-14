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

Escaped values:

If you use (Swift-)escaped values in the template, write the same as you would get if you first write the template in the usual `"..."` form with the escapes, and then adding the `#...#` around it:

```swift
print(#replacingWithTemplate(in: "1newline2", replacing: /(\d)newline(\d)/, withTemplate: #"$1\n$2"#)) // prints "1" and "2" with a newline in-between
print(#replacingWithTemplate(in: "1auml2", replacing: /(\d)auml(\d)/, withTemplate: #"$1\u{C4}$2"#)) // prints "1Ä2"
```

You really have to escape according characters:

```swift
print(#replacingWithTemplate(in: "1quote2", replacing: /(\d)quote(\d)/, withTemplate: #"$1"$2"#)) // compilation errors!
print(#replacingWithTemplate(in: "1backslash2", replacing: /(\d)backslash(\d)/, withTemplate: #"$1\$2"#)) // prints "1\(match.output.2)" without any compilation errors!
```

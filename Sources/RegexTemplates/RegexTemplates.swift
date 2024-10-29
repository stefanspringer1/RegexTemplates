import Foundation

/// This macro makes it possible to efficiently replace a regular expression with a template containing `$1`, `S2`, etc.
///
/// Example:
///
/// ```swift
/// print(#replacingWithTemplate(in: "123 hello!", replace: /([a-z]+)/, withTemplate: "$1 $1"))
/// // prints "123 hello hello!"
/// ```
///
/// Example with matching semantics `.unicodeScalar`:
///
/// ```swift
/// print(#replacingWithTemplate(in: "a\u{0307}", replace: /([a-z])\x{0307}/.matchingSemantics(.unicodeScalar), withTemplate: "$1\u{0300}"))
/// // prints "à"
/// ```
@freestanding(expression)
public macro replacingWithTemplate(in subject: String, replacing regex: any RegexComponent, withTemplate template: String) -> String = #externalMacro(module: "RegexTemplatesMacros", type: "ReplacingWithTemplate")

/// This macro makes it possible to efficiently replace a regular expression with a template containing `$1`, `S2`, etc.
///
/// Example:
///
/// ```swift
/// var text = "123 hello!"
/// #replaceWithTemplate(in: text, replace: /([a-z]+)/, withTemplate: "$1 $1"))
/// print(text)
/// // prints "123 hello hello!"
/// ```
///
/// Example with matching semantics `.unicodeScalar`:
///
/// ```swift
/// ver text = "a\u{0307}"
/// #replaceWithTemplate(in: text, replace: /([a-z])\x{0307}/.matchingSemantics(.unicodeScalar), withTemplate: "$1\u{0300}"))
/// print(text)
/// // prints "à"
/// ```
@freestanding(expression)
public macro replaceWithTemplate(in subject: String, replace regex: any RegexComponent, withTemplate template: String) = #externalMacro(module: "RegexTemplatesMacros", type: "ReplaceWithTemplate")

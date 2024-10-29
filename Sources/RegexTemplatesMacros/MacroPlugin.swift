import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ReplacingWithTemplate.self,
        ReplaceWithTemplate.self,
    ]
}

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

extension String: Error {}

public struct ReplaceWithTemplate: ExpressionMacro {
    
    public static func resolvedForm(forTemplate template: String) ->  String {
        return template.replacing(/\$([0-9]+)/.asciiOnlyCharacterClasses()) { match in
            "\\(match.output.\(Int(match.output.1)!))"
        }
    }
    
    public static func expansion<Node: FreestandingMacroExpansionSyntax,
                                 Context: MacroExpansionContext>(of node: Node,
                                                                 in context: Context) throws -> ExprSyntax {
        
        guard
            node.argumentList.count == 3
        else {
            throw "need three arguments"
        }
        
        let argumentList = Array(node.argumentList)
        let subjectArgument = argumentList[0].expression
        let regexArgument = argumentList[1].expression
        let templateArgument = argumentList[2].expression
        
        guard
            let subject = subjectArgument.as(ExprSyntax.self)
        else {
            throw "macro requires expression as first argument"
        }
        
        guard
            let regex = regexArgument.as(ExprSyntax.self)
        else {
            throw "macro requires expression as second argument"
        }
        
        guard
            let templateArgumentSegments = templateArgument.as(StringLiteralExprSyntax.self)?.segments,
            templateArgumentSegments.count == 1,
            case .stringSegment(let template)? = templateArgumentSegments.first
        else {
            throw "macro requires static string literal as third argument"
        }
        
        let expr: ExprSyntax = """
        \(raw: subject).replacing(\(raw: regex)) { match in
            \"\(raw: ReplaceWithTemplate.resolvedForm(forTemplate: "\(template)"))\"
        }
        """
        return ExprSyntax(expr)

    }
}

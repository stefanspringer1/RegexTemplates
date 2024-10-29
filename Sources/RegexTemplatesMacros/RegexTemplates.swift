import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

/// An error with a description.
///
/// When printing such an error, its descrition is printed.
struct RegexTemplateError: LocalizedError, CustomStringConvertible {

    private let message: String

    public init(_ message: String) {
        self.message = message
    }
    
    public var description: String { message }
    
    public var errorDescription: String? { message }
}

public struct ReplaceWithTemplateTools {
    
    static public func resolvedForm(forTemplate template: String) ->  String {
        return template.replacing(/\$([0-9]+)/.asciiOnlyCharacterClasses()) { match in
            "\\(match.output.\(Int(match.output.1)!))"
        }
    }
    
}

fileprivate func specifiedExpansion<Node: FreestandingMacroExpansionSyntax, Context: MacroExpansionContext>(of node: Node, in context: Context, functionName: String) throws -> ExprSyntax {
  
  guard
      node.argumentList.count == 3
  else {
      throw RegexTemplateError("need three arguments")
  }
  
  let argumentList = Array(node.argumentList)
  let subjectArgument = argumentList[0].expression
  let regexArgument = argumentList[1].expression
  let templateArgument = argumentList[2].expression
  
  guard
      let subject = subjectArgument.as(ExprSyntax.self)
  else {
      throw RegexTemplateError("macro requires expression as first argument")
  }
  
  guard
      let regex = regexArgument.as(ExprSyntax.self)
  else {
      throw RegexTemplateError("macro requires expression as second argument")
  }
  
  guard
      let templateArgumentSegments = templateArgument.as(StringLiteralExprSyntax.self)?.segments,
      templateArgumentSegments.count == 1,
      case .stringSegment(let template)? = templateArgumentSegments.first
  else {
      throw RegexTemplateError("macro requires static string literal as third argument")
  }
  
  let expr: ExprSyntax = """
  \(raw: subject).\(raw: functionName)(\(raw: regex)) { match in
      \"\(raw: ReplaceWithTemplateTools.resolvedForm(forTemplate: "\(template)"))\"
  }
  """
  return ExprSyntax(expr)

}

public struct ReplacingWithTemplate: ExpressionMacro {
    
    public static func expansion<Node: FreestandingMacroExpansionSyntax, Context: MacroExpansionContext>(of node: Node, in context: Context) throws -> ExprSyntax {
        try specifiedExpansion(of: node, in: context, functionName: "replacing")
    }
    
}

public struct ReplaceWithTemplate: ExpressionMacro {
    
    public static func expansion<Node: FreestandingMacroExpansionSyntax, Context: MacroExpansionContext>(of node: Node, in context: Context) throws -> ExprSyntax {
        try specifiedExpansion(of: node, in: context, functionName: "replace")

    }
    
}

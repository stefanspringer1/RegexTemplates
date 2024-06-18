import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import Macros
import RegexTemplates

final class RegexTemplatesTests: XCTestCase {

    func testTemplateResolving() throws {
        XCTAssertEqual(
            ReplaceWithTemplate.resolvedForm(forTemplate: "#1: $1 #1 (again): $1 #2: $2"),
            #"#1: \(match.output.1) #1 (again): \(match.output.1) #2: \(match.output.2)"#
            )
    }
    
    func testRegexTemplatesWithOneGroup() throws {
        XCTAssertEqual(
            #replaceWithTemplate(in: "123 hello!", replace: /([a-z]+)/, withTemplate: "$1 $1"),
            "123 hello hello!"
        )
    }
    
    func testRegexTemplatesWithTwoGroups() throws {
        XCTAssertEqual(
            #replaceWithTemplate(in: "123 hello!", replace: /([a-z])([a-z]+)/, withTemplate: "$1$2$2"),
            "123 helloello!"
        )
    }
     
}

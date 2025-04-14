import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import RegexTemplatesMacros
import RegexTemplates

extension String {
    var pretty: String {
        #replacingWithTemplate(in: self, replacing: /([a-z])([A-Z])(?=[a-z])/, withTemplate: "$1$2")
    }
}

final class RegexTemplatesTests: XCTestCase {
    
    func testTemplateResolving() throws {
        XCTAssertEqual(
            ReplaceWithTemplateTools.resolvedForm(forTemplate: "#1: $1 #1 (again): $1 #2: $2"),
            #"#1: \(match.output.1) #1 (again): \(match.output.1) #2: \(match.output.2)"#
        )
    }
    
    // does not compile:
//    func testRegexTemplatesWithOneGroups() throws {
//        XCTAssertEqual(
//            #replacingWithTemplate(in: "123 hello!", replacing: /[a-z]/, withTemplate: "$0 $0"),
//            "123 hello hello!"
//        )
//    }
    
    func testRegexTemplatesWithTwoGroups() throws {
        
        // converting to a new text:
        XCTAssertEqual(
            #replacingWithTemplate(in: "123 hello!", replacing: /([a-z]+)/, withTemplate: "$1 $1"),
            "123 hello hello!"
        )
        
        // changing a given text:
        var changingText = "123 hello!"
        #replaceWithTemplate(in: changingText, replace: /([a-z]+)/, withTemplate: "$1 $1")
        XCTAssertEqual(changingText, "123 hello hello!")
        
    }
    
    func testRegexTemplatesWithThreeGroups() throws {
        
        // converting to a new text:
        XCTAssertEqual(
            #replacingWithTemplate(in: "123 hello!", replacing: /([a-z])([a-z]+)/, withTemplate: "$1$2$2"),
            "123 helloello!"
        )
        
        // changing a given text:
        var changingText = "123 hello!"
        #replaceWithTemplate(in: changingText, replace: /([a-z])([a-z]+)/, withTemplate: "$1$2$2")
        XCTAssertEqual(changingText, "123 helloello!")
        
    }
    
    func testRegexTemplatesCodepoints() throws {
        
        // converting to a new text:
        XCTAssertEqual(
            #replacingWithTemplate(in: "a\u{0307}", replacing: /([a-z])\x{0307}/.matchingSemantics(.unicodeScalar), withTemplate: "$1\u{0300}"),
            "à"
        )
        
        // changing a given text:
        var changingText = "a\u{0307}"
        #replaceWithTemplate(in: changingText, replace: /([a-z])\x{0307}/.matchingSemantics(.unicodeScalar), withTemplate: "$1\u{0300}")
        XCTAssertEqual(changingText, "à")
        
    }
    
    func testWithQuotes() {
        var text = #"<form name="myName" id="myID" style="display:inline">"#
        #replaceWithTemplate(in: text, replace: /name="([^"]*)" id="([^"]*)"/, withTemplate: #"id=\"$2\" name=\"$1\""#)
        XCTAssertEqual(text,#"<form id="myID" name="myName" style="display:inline">"#)
    }
    
    func testWithNewline() {
        var text = "1newline2"
        #replaceWithTemplate(in: text, replace: /(\d)newline(\d)/, withTemplate: #"$1\n$2"#)
        XCTAssertEqual(text,"""
            1
            2
            """)
    }
    
    func testWithNumericCharacterReference() {
        var text = "1auml2"
        #replaceWithTemplate(in: text, replace: /(\d)auml(\d)/, withTemplate: #"$1\u{C4}$2"#)
        XCTAssertEqual(text,"1Ä2")
    }
    
}

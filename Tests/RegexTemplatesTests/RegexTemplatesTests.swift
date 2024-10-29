import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import RegexTemplatesMacros
import RegexTemplates

final class RegexTemplatesTests: XCTestCase {
    
    // does not compile:
//    func testRegexTemplatesWithOneGroups() throws {
//        XCTAssertEqual(
//            #replacingWithTemplate(in: "123 hello!", replace: /[a-z]/, withTemplate: "$0 $0"),
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
     
}

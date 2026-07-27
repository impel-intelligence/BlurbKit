//
//  ProtocolTests.swift
//  IrisSearch
//
//  Created by Taylor Lineman on 6/17/26.
//

import Testing
@testable import BlurbKit
import Foundation
import UniformTypeIdentifiers

struct FactoryTests {
    @Test("Ensure the text digester is returned by the factory is correct for various text UTTypes.", arguments: [
        UTType.plainText,
        UTType.cHeader,
        UTType.cSource,
        UTType.swiftSource,
        UTType("net.daringfireball.markdown")!
    ]) func testTxtDigesterReturned(utType: UTType) throws {
        let returnedDigester = try BlurbFactory.provider(for: utType)
        #expect(type(of: TextBlurbProvider()) == type(of: returnedDigester))
    }
    
    
    @Test("Ensure the pdf digester is returned by the factory is correct for various pdf UTTypes.", arguments: [
        UTType.pdf,
    ]) func testPDFDigesterReturned(utType: UTType) throws {
        let returnedDigester = try BlurbFactory.provider(for: utType)
        #expect(type(of: PDFBlurbProvider()) == type(of: returnedDigester))
    }
}

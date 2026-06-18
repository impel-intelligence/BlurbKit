//
//  PDFBlurbProviderTests.swift
//  BlurbKit
//
//  Created by Taylor Lineman on 6/18/26.
//

import Testing
import Foundation
@testable import BlurbKit

struct PDFBlurbProviderTests {
    struct TestArgument {
        let url: URL
        let expectedBlurb: Blurb
    }
    
    @Test("Test the non-async version of blurb generation", arguments: [
        TestArgument(
            url: Bundle.module.url(forResource: "somatosensory", withExtension: "pdf", subdirectory: "Resources/pdf")!,
            expectedBlurb: Blurb(
                title: "somatosensory",
                description: "Anatomy of the Somatosensory System"
            )
        ),
        TestArgument(
            url: Bundle.module.url(forResource: "X86_Disassembly", withExtension: "pdf", subdirectory: "Resources/pdf")!,
            expectedBlurb: Blurb(
                title: "X86_Disassembly",
                description: "X86 Disassembly"
            )
        )
    ]) func testNoAsync(argument: TestArgument) throws {
        let blurb = try PDFBlurbProvider().blurb(for: argument.url)
        #expect(argument.expectedBlurb == blurb)
    }
    
    @Test("Test the async version of blurb generation", arguments: [
        Bundle.module.url(forResource: "somatosensory", withExtension: "pdf", subdirectory: "Resources/pdf")!,
        Bundle.module.url(forResource: "X86_Disassembly", withExtension: "pdf", subdirectory: "Resources/pdf")!,
    ]) func testAsync(url: URL) async throws {
        // TODO: Test with the evaluations framework on os27
        let blurb = try await PDFBlurbProvider().blurb(for: url)
        print(blurb)
    }
    
}


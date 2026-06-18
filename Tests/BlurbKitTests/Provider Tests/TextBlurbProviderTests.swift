//
//  TextBlurbProviderTests.swift
//  BlurbKit
//
//  Created by Taylor Lineman on 6/18/26.
//

import Testing
import Foundation
@testable import BlurbKit

struct TextBlurbProviderTests {
    struct TestArgument {
        let url: URL
        let expectedBlurb: Blurb
    }
    
    @Test("Test the non-async version of blurb generation", arguments: [
        TestArgument(
            url: Bundle.module.url(forResource: "Shakespeare", withExtension: "txt", subdirectory: "Resources/txt")!,
            expectedBlurb: Blurb(
                title: "Shakespeare",
                description: "The Project Gutenberg eBook of The Complete Works of William Shakespeare"
            )
        ),
        TestArgument(
            url: Bundle.module.url(forResource: "ShakespeareOneLine", withExtension: "txt", subdirectory: "Resources/txt")!,
            expectedBlurb: Blurb(
                title: "ShakespeareOneLine",
                description: "The Project Gutenberg eBook of The Complete Works of William Shakespeare This ebook is for the use of anyone anywhere in the United States an"
            )
        )
    ]) func testNoAsync(argument: TestArgument) throws {
        let blurb = try TextBlurbProvider().blurb(for: argument.url)
        #expect(argument.expectedBlurb == blurb)
    }
    
    @Test("Test the async version of blurb generation", arguments: [
        Bundle.module.url(forResource: "Shakespeare", withExtension: "txt", subdirectory: "Resources/txt")!,
        Bundle.module.url(forResource: "ShakespeareOneLine", withExtension: "txt", subdirectory: "Resources/txt")!
    ]) func testAsync(url: URL) async throws {
        // TODO: Test with the evaluations framework on os27
        let blurb = try await TextBlurbProvider().blurb(for: url)
        print(blurb)
    }

}


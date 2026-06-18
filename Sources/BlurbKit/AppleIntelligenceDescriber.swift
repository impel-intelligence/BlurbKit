//
//  AppleIntelligenceDescriber.swift
//  BlurbKit
//
//  Created by Taylor Lineman on 6/18/26.
//

import Foundation
import FoundationModels

@available(macOS 26.0, iOS 26.0, tvOS 26.0, visionOS 26.0, *)
struct AppleIntelligenceDescriber {
    enum IntelligenceError: Error {
        case intelligenceModelNotAvailable
    }

    static func createDescription(for content: String) async throws -> String {
        let model = SystemLanguageModel.default
        guard model.isAvailable else { throw IntelligenceError.intelligenceModelNotAvailable }
        let session = LanguageModelSession(instructions: "Create a three sentence summary of this file.")
        
        let shortenedContent = content.first(characters: 2048)
        let response = try await session.respond(to: shortenedContent)
        return response.content
    }
}

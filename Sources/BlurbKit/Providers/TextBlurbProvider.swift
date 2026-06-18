//
//  TextBlurbProvider.swift
//  BlurbKit
//
//  Created by Taylor Lineman on 6/18/26.
//

import UniformTypeIdentifiers
import FoundationModels

public struct TextBlurbProvider: BlurbProvider {
    public enum TextBlurbProviderError: Error {
        case intelligenceModelNotAvailable
    }
    
    public static let fileTypes: [UTType] = [.text, .plainText, .utf8PlainText, .utf16PlainText, .utf16ExternalPlainText, UTType("com.unkown.md")!]

    let descriptionCharacterLength = 140
    
    public init() { }
    
    public func blurb(for url: URL) async throws -> Blurb {
        guard url.isFileURL else { throw BlurbProviderError.notALocalFile }
        let content = try getContent(url: url)
        
        // Attempt to create a description using Apple's intelligence models
        var description: String

        do {
            if #available(macOS 26.0, iOS 26.0, tvOS 26.0, visionOS 26.0, *) {
                description = try await AppleIntelligenceDescriber.createDescription(for: content)
            } else {
                description = createDescription(for: content)
            }
        } catch {
            description = createDescription(for: content)
        }

        return Blurb(title: url.name(), description: description)
    }
    
    public func blurb(for url: URL) throws -> Blurb {
        guard url.isFileURL else { throw BlurbProviderError.notALocalFile }
        
        let content = try getContent(url: url)
        let description = createDescription(for: content)
        
        return Blurb(title: url.name(), description: description)
    }
    
    private func getContent(url: URL) throws -> String {
        var encoding: String.Encoding = .utf8
        return try String(contentsOf: url, usedEncoding: &encoding)
    }
    
    private func createDescription(for content: String) -> String {
        // If we can get the first line of the document, grab it.
        var contentForDescription: String = content
        if let firstLine = content.split(separator: "\n").first {
            contentForDescription = String(firstLine)
        }
        
        return contentForDescription.first(characters: descriptionCharacterLength)
    }
}

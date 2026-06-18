// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UniformTypeIdentifiers

enum BlurbProviderError: Error {
    case notALocalFile
    case fileNotReadable
    case unsupportedMimeType
}

public protocol BlurbProvider: Sendable {
    /// File types that the provider can generate blurbs for. Incoming UTTypes are checked using `.conforms(to:)`.
    static var fileTypes: [UTType] { get }
    
    /// A basic initializer to ensure the factory can return an instantiated version of a provider.
    init()
    
    /// Retrieve a ``Blurb``, where asynchronous operations are used to retrieve content.
    ///
    /// - Parameter url: The URL to create a ``Blurb`` for.
    /// - Returns: A ``Blurb`` that represents the provided `url`.
    func blurb(for url: URL) async throws -> Blurb
    
    /// Retrieve a synchronous blurb for the given URL.
    /// 
    /// - Parameter url: The URL to create a ``Blurb`` for.
    /// - Returns: A ``Blurb`` that represents the provided `url`.
    func blurb(for url: URL) throws -> Blurb
}

extension BlurbProvider {
    
    /// Check to see if a UTType can be excepted by this provider.
    /// - Parameter type: The type to check for conformance.
    /// - Returns: True if the provider can process a file of `type`.
    static func isValidType(_ type: UTType) -> Bool {
        return Self.fileTypes.contains(where: { type.conforms(to: $0) })
    }
}

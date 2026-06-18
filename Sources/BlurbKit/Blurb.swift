//
//  Blurb.swift
//  BlurbKit
//
//  Created by Taylor Lineman on 6/18/26.
//

/// A set of short pieces of content that represents the content of an entire file, webpage, etc...
public struct Blurb: Sendable {
    /// The title of the URL
    public let title: String
    /// A description of the URL's content
    public let description: String
}

extension Blurb: Equatable { }

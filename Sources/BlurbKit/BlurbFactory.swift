//
//  BlurbFactory.swift
//  BlurbKit
//
//  Created by Taylor Lineman on 6/18/26.
//

import Foundation
import UniformTypeIdentifiers

public struct BlurbFactory {
    enum BlurbFactoryError: Error {
        case noAvailableProvider(type: UTType)
    }
    
    private static let registeredProviders: [any BlurbProvider.Type] = [TextBlurbProvider.self, PDFBlurbProvider.self]
    
    public static var availableUniformTypes: [UTType] {
        return registeredProviders.flatMap({$0.fileTypes})
    }
    
    public static func provider(for type: UTType) throws -> any BlurbProvider {
        guard let digesterType = registeredProviders.first(where: { $0.isValidType(type) }) else {
            throw BlurbFactoryError.noAvailableProvider(type: type)
        }
        
        return digesterType.init()
    }
}

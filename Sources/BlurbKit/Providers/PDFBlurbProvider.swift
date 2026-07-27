//
//  PDFBlurbProvider.swift
//  BlurbKit
//
//  Created by Taylor Lineman on 6/18/26.
//

import UniformTypeIdentifiers
import FoundationModels
import PDFKit

public struct PDFBlurbProvider: BlurbProvider {
    public enum PDFBlurbProviderError: Error {
        case urlNotAValidPDF
        case noTextInDocument
    }
    
    public static let fileTypes: [UTType] = [.pdf]

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
        guard let document = PDFDocument(url: url) else { throw PDFBlurbProviderError.urlNotAValidPDF }
        guard let content = document.string else { throw PDFBlurbProviderError.noTextInDocument }
        return content
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

//final class PDFDigester: FileDigester, Sendable {
//    static let fileTypes: [UTType] = [.pdf, UTType("com.adobe.pdf")!]
//    
//    required init() {
//        
//    }
//    
//    /// Render PDF pages to CGImages
//    /// This runs fairly quickly, with a 200 page document taking around ​0.13 seconds. It is not instead, but fairly close.
//    ///
//    /// - Parameter pages: the PDFPages to render from
//    /// - Returns: A set of CGImages for each page in the PDF, rendered at the same size they are in the PDF.
//    func renderPages(from pages: [SendablePage]) async throws -> [RenderedPage] {
//        return try await withThrowingTaskGroup(of: RenderedPage?.self) { group in
//            for wrapper in pages {
//                group.addTask {
//                    let page = wrapper.page
//                    let rect = page.bounds(for: .mediaBox)
//                    
//                    guard let context = CGContext(
//                        data: nil,
//                        width: Int(rect.width),
//                        height: Int(rect.height),
//                        bitsPerComponent: 8,
//                        bytesPerRow: 0,
//                        space: CGColorSpaceCreateDeviceRGB(),
//                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
//                    ) else { return nil }
//                    
//                    page.draw(with: .mediaBox, to: context)
//                    guard let image = context.makeImage(), let jpgData = image.jpgData else { return nil }
//                    return RenderedPage(index: wrapper.index, jpgData: jpgData, label: page.label)
//                }
//            }
//            
//            var renderedPages: [RenderedPage] = []
//            
//            // Gather results as they finish
//            for try await result in group {
//                guard let page = result else { continue }
//                renderedPages.append(page)
//            }
//            
//            return renderedPages
//        }
//    }
//    
//    func extractText(from pages: [SendablePage]) async throws -> [String] {
//        return try await withThrowingTaskGroup(of: String?.self) { group in
//            for wrapper in pages {
//                group.addTask {
//                    return wrapper.page.string
//                }
//            }
//            
//            var extractedPages: [String] = []
//            
//            // Gather results as they finish
//            for try await result in group {
//                guard let content = result else { continue }
//                extractedPages.append(content)
//            }
//            
//            return extractedPages
//        }
//    }
//    
//    func digest(file: URL) async throws -> [EmbeddableContent] {
//        // Will bail out if the url is not valid
//        try PDFDigester.validateLocalURL(file)
//        
//        guard let data = FileManager.default.contents(atPath: file.path(percentEncoded: false)) else { throw DigestionError.failedToReadContents }
//        
//        guard let pdfDocument = PDFDocument(data: data) else { throw PDFDigestionError.couldNotCreateDocument }
//        
//        let pages: [SendablePage] = (0..<pdfDocument.pageCount).compactMap { index in
//            guard let page = pdfDocument.page(at: index) else { return nil }
//            return SendablePage(page: page, label: page.label, index: index)
//        }
//        
//        var contentPieces: [EmbeddableContent] = []
//        
//        // Process both the page text and images at the same time.
//        async let textPieces = extractText(from: pages)
//        async let renderedPages: [RenderedPage] = renderPages(from: pages)
//        
//        // If per-page string extraction failed, extract all of the text in the PDF.
//        if try await textPieces.isEmpty, let content = pdfDocument.string {
//            contentPieces.append(.text(content: content))
//        } else {
//            for page in try await textPieces {
//                contentPieces.append(.text(content: page))
//            }
//        }
//        
//        for page in try await renderedPages {
//            contentPieces.append(.image(content: page.jpgData, caption: page.label ?? "Page \(page.index) of PDF"))
//        }
//        
//        return contentPieces
//    }
//}

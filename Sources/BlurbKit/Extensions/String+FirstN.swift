//
//  String+FirstN.swift
//  BlurbKit
//
//  Created by Taylor Lineman on 6/18/26.
//

extension String {
    func first(characters: Int) -> String {
        let start = self.startIndex
        let end = self.index(start, offsetBy: characters, limitedBy: self.endIndex) ?? self.endIndex
        return String(self[start..<end])

    }
}

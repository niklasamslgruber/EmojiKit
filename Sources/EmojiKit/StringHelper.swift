//
//  StringHelper.swift
//  
//
//  Created by Niklas Amslgruber on 10.06.23.
//

import Foundation

extension String {

    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func asEmoji() -> String? {
        guard let unicodeNumber = Int(self, radix: 16), let unicode = Unicode.Scalar(unicodeNumber) else {
            return nil
        }
        return String(unicode)
    }
}

extension String.SubSequence {

    func trim() -> String {
        return String(self).trim()
    }

    func asEmoji() -> String? {
        return String(self).asEmoji()
    }
}

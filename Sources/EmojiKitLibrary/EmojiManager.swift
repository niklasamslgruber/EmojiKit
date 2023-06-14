//
//  EmojiManager.swift
//  Travely
//
//  Created by Niklas Amslgruber on 13.06.23.
//

import Foundation

public enum EmojiManager {
    
    public enum Version: Int {
        case v14 = 14
        case v15 = 15
        
        public var fileName: String {
            return "emojis_v\(rawValue)"
        }
        
        public static func getSupportedVersion() -> Version {
            if #available(iOS 16.4, *) {
                return .v15
            } else {
                return .v14
            }
        }
    }

    /// Returns all emojis for a specific version
    /// - Parameters:
    ///   - version: The specific version you want to fetch (default: the highest supported version for a device's iOS version)
    ///   - showAllVariations: Some emojis inlcude skin type variations which increases the number of emojis drastically. (default: only the yellow neutral emojis are returned)
    /// - Returns: Array of categories with all emojis that are assigned to each category
    public static func getAvailableEmojis(version: Version = .getSupportedVersion(), showAllVariations: Bool = false) -> [EmojiCategory] {
        if let url = Bundle.main.url(forResource: version.fileName, withExtension: "json"), let content = try? Data(contentsOf: url), let result = try? JSONDecoder().decode([EmojiCategory].self, from: content) {
            var filteredEmojis: [EmojiCategory] = []
            for category in result {
                let supportedEmojis = category.values.filter({
                    showAllVariations ? true : isNeutralEmoji(for: $0)
                })
                filteredEmojis.append(EmojiCategory(name: category.name, values: supportedEmojis))
            }
            return filteredEmojis
        }
        return []
    }
    
    private static func isNeutralEmoji(for emoji: String) -> Bool {
        let unicodes = getUnicodes(emoji: emoji)
        let colors = ["1F3FB", "1F3FC", "1F3FD", "1F3FE", "1F3FF"]
        
        for color in colors where unicodes.contains(color) {
            return false
        }
        return true
    }
    
    private static func getUnicodes(emoji: String) -> [String] {
        let unicodeScalars = emoji.unicodeScalars
        let unicodes = unicodeScalars.map { $0.value }
        return unicodes.map { String($0, radix: 16, uppercase: true) }
    }
}

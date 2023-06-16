//
//  EmojiManager.swift
//  Travely
//
//  Created by Niklas Amslgruber on 13.06.23.
//

import Foundation

public enum EmojiManager {
    
    public enum Version: Double {
        case v13_1 = 13.1
        case v14 = 14
        case v15 = 15
        
        public var fileName: String {
            return "emojis_v\(versionIdentifier)"
        }

        public var versionIdentifier: String {
            switch self {
            case .v13_1:
                return "13.1"
            case .v14:
                return "14.0"
            case .v15:
                return "15.0"
            }
        }
        
        public static func getSupportedVersion() -> Version {
            if #available(iOS 16.4, *) {
                return .v15
            } else if #available(iOS 15.4, *) {
                return .v14
            } else {
                return .v13_1
            }
        }
    }

    /// Returns all emojis for a specific version
    /// - Parameters:
    ///   - version: The specific version you want to fetch (default: the highest supported version for a device's iOS version)
    ///   - showAllVariations: Some emojis inlcude skin type variations which increases the number of emojis drastically. (default: only the yellow neutral emojis are returned)
    ///   - url: Specify the location of the `emoji_v<version_number>.json` files if needed (default: bundle resource path)
    /// - Returns: Array of categories with all emojis that are assigned to each category
    public static func getAvailableEmojis(version: Version = .getSupportedVersion(), showAllVariations: Bool = false, at url: URL? = nil) -> [EmojiCategory] {
        let fileUrl = url ?? Bundle.module.url(forResource: version.fileName, withExtension: "json")
        if let url = fileUrl, let content = try? Data(contentsOf: url), let result = try? JSONDecoder().decode([EmojiCategory].self, from: content) {
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

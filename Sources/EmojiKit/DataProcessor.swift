//
//  DataProcessor.swift
//  
//
//  Created by Niklas Amslgruber on 12.06.23.
//

import Foundation

public enum DataProcessor {

    public enum EmojiUnicodeVersion: Int {
        case v14 = 14
        case v15 = 15

        public var fileName: String {
            return "emojis_v\(rawValue).json"
        }

        public static func getSupportedVersionForCurrentIOSVersion() -> EmojiUnicodeVersion {
            if #available(iOS 16.4, *) {
                return .v15
            } else {
                return .v14
            }
        }
    }

    public enum SkinType {
        case neutral
        case light
        case mediumLight
        case medium
        case mediumDark
        case dark

        var unicode: String {
            switch self {
            case .neutral:
                return ""
            case .light:
                return "1F3FB"
            case .mediumLight:
                return "1F3FC"
            case .medium:
                return "1F3FD"
            case .mediumDark:
                return "1F3FE"
            case .dark:
                return "1F3FF"
            }
        }
    }

    public static func getEmojis(at url: URL, for version: EmojiUnicodeVersion, skinTypes: [SkinType] = [.neutral]) -> [EmojiCategory] {
        guard let content = try? Data(contentsOf: url), let result = try? JSONDecoder().decode([EmojiCategory].self, from: content)  else {
            return []
        }

        var filteredEmojis: [EmojiCategory] = []
        for wrapper in result {
            let supportedEmojis = wrapper.values.filter({
                isMatchingSkinType(of: $0, for: skinTypes)
            })
            filteredEmojis.append(EmojiCategory(name: wrapper.name, values: supportedEmojis))
        }
        return filteredEmojis
    }

    private static func isMatchingSkinType(of emoji: String, for skinTypes: [SkinType]) -> Bool {
        let unicodes = getUnicodes(emoji: emoji)

        for skinType in skinTypes where unicodes.contains(skinType.unicode) {
            return true
        }

        return false
    }

    private static func getUnicodes(emoji: String) -> [String] {
        let unicodeScalars = emoji.unicodeScalars
        let unicodes = unicodeScalars.map { $0.value }
        return unicodes.map { String($0, radix: 16, uppercase: true) }
    }
}

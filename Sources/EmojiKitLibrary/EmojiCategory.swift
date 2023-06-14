//
//  EmojiCategory.swift
//  
//
//  Created by Niklas Amslgruber on 10.06.23.
//

import Foundation

public class EmojiCategory: Codable {

    public enum Name: String, CaseIterable, Codable {
        case flags = "Flags"
        case activities = "Activities"
        case components = "Component"
        case objects = "Objects"
        case travelAndPlaces = "Travel & Places"
        case symbols = "Symbols"
        case peopleAndBody = "People & Body"
        case animalsAndNature = "Animals & Nature"
        case foodAndDrink = "Food & Drink"
        case smileysAndEmotions = "Smileys & Emotion"

        public static var orderedCases: [EmojiCategory.Name] {
            return EmojiCategory.Name.allCases.sorted(by: { $0.order < $1.order })
        }

        // Order that Apple uses in their emoji picker
        public var order: Int {
            switch self {
            case .flags:
                return 10
            case .activities:
                return 5
            case .components:
                return 8
            case .objects:
                return 7
            case .travelAndPlaces:
                return 6
            case .symbols:
                return 9
            case .peopleAndBody:
                return 2
            case .animalsAndNature:
                return 3
            case .foodAndDrink:
                return 4
            case .smileysAndEmotions:
                return 1
            }
        }
    }

    public let name: Name
    public let values: [String]

    public init(name: Name, values: [String]) {
        self.name = name
        self.values = values
    }
}

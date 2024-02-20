//
//  AppleEmojiCategory.swift
//  
//
//  Created by Niklas Amslgruber on 19.02.24.
//

import Foundation

public class AppleEmojiCategory: Codable {

    public enum Name: String, CaseIterable, Codable {
        case flags = "Flags"
        case activity = "Activity"
        case objects = "Objects"
        case travelAndPlaces = "Travel & Places"
        case symbols = "Symbols"
        case animalsAndNature = "Animals & Nature"
        case foodAndDrink = "Food & Drink"
        case smileysAndPeople = "Smileys & People"

        public static var orderedCases: [Name] {
            return allCases.sorted(by: { $0.order < $1.order })
        }

        public var order: Int {
            switch self {
            case .flags:
                return 8
            case .activity:
                return 4
            case .objects:
                return 6
            case .travelAndPlaces:
                return 5
            case .symbols:
                return 7
            case .animalsAndNature:
                return 2
            case .foodAndDrink:
                return 3
            case .smileysAndPeople:
                return 1
            }
        }
    }

    public let name: Name
    public var values: [String]

    public init(name: Name, values: [String]) {
        self.name = name
        self.values = values
    }

}

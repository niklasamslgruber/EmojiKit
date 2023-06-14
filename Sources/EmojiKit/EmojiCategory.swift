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
    }

    public let name: Name
    public let values: [String]

    public init(name: Name, values: [String]) {
        self.name = name
        self.values = values
    }
}

//
//  EmojiScripts.swift
//  
//
//  Created by Niklas Amslgruber on 12.06.23.
//

import Foundation
import ArgumentParser

@main
struct EmojiScripts: ParsableCommand, AsyncParsableCommand {

    #if os(macOS)
    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "emojis",
        abstract: "Manage Emojis from Unicode",
        subcommands: [
            EmojiDownloader.self
        ]
    )
    #endif
}

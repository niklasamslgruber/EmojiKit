//
//  File.swift
//  
//
//  Created by Niklas Amslgruber on 10.06.23.
//

import Foundation
import ArgumentParser
import EmojiKitLibrary

struct EmojiDownloader: ParsableCommand, AsyncParsableCommand {

    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "download",
        abstract: "Downloads a list of all available emojis and their counts from unicode.rog for the respective unicode version"
    )

    @Argument var path: String
    @Option(name: .shortAndLong) var version: EmojiManager.Version = .v13_1

    private func getPath() -> String {
        #if DEBUG
        var url = URL(filePath: #file)
        url = url.deletingLastPathComponent().deletingLastPathComponent()
        url.append(path: "EmojiKitLibrary/Resources")

        return url.absoluteString
        #else
        return path
        #endif
    }

    func run() async throws {
        print("⚙️", "Starting to download all emojis for version \(version.rawValue) from unicode.org...\n")

        guard let emojiListURL = await getTemporaryURLForEmojiList(version: version), let emojiCountsURL = await getTemporaryURLForEmojiCounts(version: version) else {
            print("⚠️", "Could not get content from unicode.org. Either the emoji list or the emoji count file is not available.\n")
            return
        }

        print("🎉", "Successfully retrieved temporary URLs for version \(version.rawValue).\n")

        print("⚙️", "Starting to parse content...\n")

        let parser = UnicodeParser()

        do {
            let emojisByCategory: [EmojiCategory] = try await parser.parseEmojiList(for: emojiListURL)

            let emojiCounts: [EmojiCategory.Name: Int] = parser.parseCountHTML(for: emojiCountsURL)

            for category in emojisByCategory {
                assert(emojiCounts[category.name] == category.values.count)
            }

            print("🎉", "Successfully parsed emojis and matched counts to the count file.\n")

            save(data: emojisByCategory, for: version)

            print("🎉", "Successfully saved emojis to file.\n")

        } catch {
            print("⚠️", "Could not parse emoji lists or emoji counts. Process failed with: \(error).\n")
        }
    }

    func getTemporaryURLForEmojiList(version: EmojiManager.Version) async -> URL? {
        return await load(urlString: "https://unicode.org/Public/emoji/\(version.versionIdentifier)/emoji-test.txt")
    }

    func getTemporaryURLForEmojiCounts(version: EmojiManager.Version) async -> URL? {
        return await load(urlString: "https://www.unicode.org/emoji/charts-\(version.versionIdentifier)/emoji-counts.html")
    }

    private func load(urlString: String) async -> URL? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        let session = URLSession(configuration: .default)

        do {
            let (tmpFileURL, response) = try await session.download(from: url)

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else {
                print("⚠️", "Failed with a non 200 HTTP status")
                return nil
            }
            return tmpFileURL
        } catch {
            print("⚠️", error)
            return nil
        }
    }

    private func save(data: [EmojiCategory], for: EmojiManager.Version) {
        var directory = getPath()

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        guard let result = try? encoder.encode(data) else {
            print("⚠️", "Couldn't encode emoji categories.")
            return
        }

        var filePath = URL(filePath: directory)
        filePath.append(path: version.fileName)
        let jsonString = String(data: result, encoding: .utf8)

        print("⚙️", "Saving emojis to file \(filePath.absoluteString)...\n")

        if FileManager.default.fileExists(atPath: filePath.absoluteString) == false {
            FileManager.default.createFile(atPath: filePath.absoluteString, contents: nil)
        }

        do {
            try jsonString?.write(to: filePath, atomically: true, encoding: .utf8)
        } catch {
            print("⚠️", error)
        }
    }
}

extension EmojiManager.Version: ExpressibleByArgument {}

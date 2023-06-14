# EmojiKit

A lightweight script that queries all available emoji releases from [Unicode.org](unicode.org) and makes them easily available in any product for the Apple ecosystem. 

## Usage

The main idea behind this script is that there is no full list of supported emojis that can be easily used in Swift. This script fetches the full list of emojis from [Unicode.org](unicode.org), parses them and returns a structured `.json` file where all emojis are sorted in their official category. The `.json` files can be easily read afterwards for further usage in any product.

1. Clone this repository and `cd` into the repository 
2. Run `swift run -c release EmojiKit` to build the package
3. Move the product into `/usr/local/bin` to make it available systemwide with `cp .build/release/EmojiKit /usr/bin/emojiKit`
4. Call the script from anywhere with `emojiKit download <path> -v <version>

> Alternatively you can simply run `sh build.sh` to do steps 2. and 3. in one go.

### Arguments:
* **path**: Specify the directory where the `emoji_v<version>.json` file should be stored. Only provide the directory like `/Desktop` or `.` for the current directory, not the whole file path.
* **version (--version, -v)**: New emojis are released yearly (in general). Currently only version `14` and `15` (latest) are supported. But you can easily extend the script by adding new cases to the `EmojiUnicodeVersion` enum. 

## Usage with Xcode
> Swift Package Manager and CocoaPods support is planned for the future. Currently, you need to do some manual steps to use the emojis with Xcode and Swift.

1. In your Xcode project, add a file called `emoji_v<version>` to your assets, Make sure that they are included under *Build Phases - Copy Bundle Resources* (if not add them manually there). For each version (currently `v14` and `v15`) you need to add a separate file into Xcode.
2. Run the script as describe above and specify the directory of the files you added in Xcode as the `<path>` argument.
3. The script will query the emojis and saves them to your files in Xcode.
4. Afterwards you're ready to use them in Xcode by either reading the data yourself or using the `EmojiManager.swift` included in this repository.
5. Simply copy the `EmojiManager.swift` and `EmojiCategory.swift` files into your Xcode project.
6. Afterwards you can load the emojis by calling `EmojiManager.getAvailableEmojis()`. The manager automatically fetches the correct unicode version depending on the device's iOS version to only show supported ones *(you need to run the script for all supported versions first to make the automatic loading work)*. 

> **Note:** Version 14 includes all emojis that are supported on devices from `iOS 15.4` to `<iOS 16.4`. Devices with an iOS Version `>iOS 16.5` require version 15.

## Error Handling
* If you see emojis on your device that are displayed as a `?` you're most likely running your App on a device below `iOS 15.4`. Anything below `iOS 15.4` is unfortunately not supported. If you still want to use it simply add a new case in the `EmojiUnicodeVersion`, e.g. `v13 = 13` to make it work (no guarantees though).
* If the `EmojiManager` doesn't return any emojis, there are two possible reasons. First, you didn't run the script for the version you're trying to load, so your `.json` files are empty or non-existent. Simply run the script for all supported version and it should work. If not make sure that the `.json` files are included in the *Build Phases - Copy Bundle Resources* for each target that wants to use the `EmojiManager`.




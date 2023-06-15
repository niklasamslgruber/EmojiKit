[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fniklasamslgruber%2FEmojiKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/niklasamslgruber/EmojiKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fniklasamslgruber%2FEmojiKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/niklasamslgruber/EmojiKit)

# EmojiKit

A lightweight Swift package that gives you access to all available emojis for each iOS version. Additionally, this repository includes a script to fetch all emojis for a specific release from [Unicode.org](unicode.org).

## Installation
The repository includes to different products with different use cases:

* `EmojiKit`: A Swift Package Manager (SPM) package that provides all available emojis for supported iOS versions. It already includes all supported for all iOS version higher or equal than `iOS 15.0`.
* `EmojiSourceKit`: A script that fetches emoji releases from [Unicode.org](unicode.org), parses them and stores them in easy-to-use `json` files.

In most cases it is enough to just use the `EmojiKit` for your app. The `EmojiSourceKit` is only needed if you want to fetch releases manually or fetch older non-supported unicode versions. 

## EmojiKit

### Installation

##### SwiftPM

```
https://github.com/niklasamslgruber/EmojiKit
```

### Usage

The SPM package provides an easy-to-use `EmojiManager` that parses the stored emoji files and returns them as an Array of `EmojiCategory`. Each category is the official unicode category and includes all emojis that are assigned to this category. In total these are 10 categories while the `.component` category can be ignored in most cases.

#### Get all supported emojis
```swift
import EmojiKit

let emojisByCategory: [EmojiCategory] = EmojiManager.getAvailableEmojis()
```

**Parameters:**
* `version`: By default the `EmojiManager` always returns the highest unicode version that is supported on a user's device. You can also manually specify a version which could lead to some emojis being displayed as `'?'` if the unicode version does not match the user's iOS version.
* `showAllVariations`: Many emojis are available in different skin types. By default the `EmojiManager` returns only the neutral (yellow) version of each emoji. If you want to receive all version, set this parameter to `true`.
* `at url`: If you don't want to use the emoji files that are already included in this package, you can manually specify the location of your emoji_<version>.json`. 

## EmojiSourceKit

> In most cases this part is not necessary if you just want to get the emojis in Swift. If you want to do some manual fetching or your app supports iOS versions below `iOS 15.0`, this chapter is for you.

The main idea behind this script is that there is no full list of supported emojis that can be easily used in Swift. This script fetches the full list of emojis from [Unicode.org](unicode.org), parses them and returns a structured `emojis_vX.json` file where all emojis are assigned to their official unicode category. The `.json` files can be easily parsed afterwards for further usage in any product.

### Installation

##### Manual

```bash
git clone https://github.com/niklasamslgruber/EmojiKit
```

To use `EomjiSourceKit` as a script from your Terminal, some further steps are required:

1. Clone the repository and `cd` into it.
2. Run `swift run -c release EmojiSourceKit` to build the package.
3. Move the product into `/usr/local/bin` to make it available systemwide with `cp .build/release/EmojiSourceKit /usr/bin/emojiSourceKit`.

> Alternatively you can simply run `sh build.sh` to do steps 2. and 3. in one go.

#### Execution
```bash
emojiSourceKit download <path> -v <version>
```

**Arguments:**
* `path`: Specify the directory where the `emoji_v<version>.json` file should be stored. Only provide the directory like `/Desktop` or `.` for the current directory, not the whole file path.
* `version (--version, -v)`: Currently only version `14` and `15` (latest) are supported. 

#### Working with unsupported Versions
Currently only to Unicode releases are supported (Version 14 and 15). If you want to have access to emojis from older versions, you need to edit the source code manually.

1. Add a new enum case to the `EmojiManager.Version` enum. For example for Version 12, you would need to add `case v12 = 12`. Also, add a `versionIdentifier`. This should match the release number from Unicode.rog **exactly**. You can find all releases [here](https://unicode.org/Public/emoji/). 
2. Modify the `getSupportedVersion` function to return your new enum case for the corresponding iOS version.
3. Run the script with the `emojiSourceKit download <path> --version 12` argument to get the emojis from the version 12 release.
4. Add the emoji file to your Xcode project and specify its url as an parameter of the `EmojiManager.getAvailableEmojis(at: <url)` function to access the emojis in Swift.

## Troubleshooting
1. **Emojis are rendered as <`?`> in my app:**
	
	If you're using the `EmojiKit` you're most likely running the App on a device with an iOS version below `iOS 15.0`. That is currently not supported. To still make it work, follow the instructions of running `EmojiSourceKit` with unsupported versions to get all emojis that are supported on your device's iOS version.
	
2. **The `EmojiManager` does not return any emojis when using the `url` parameter:**

	In that case make sure that you added the `emojis_vX.json` file to your Xcode project. The file name must match the version you're trying to fetch emojis for, e.g. for version 12 the file name must be `emojis_v12.json`. Additionally make sure that your JSON file is added under `Build Phase - Copy Bundle Resources` for each target where you want to use the `EmojiManager`.


import Foundation

public extension String {
    static func makeRandom(length: Int) -> String {
        return makeRandom(length: length,
                          allowedChars: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    }
    
    static func makeRandom(length: Int, allowedChars: String) -> String {
        let allowedCharsStr = allowedChars as NSString
        return (0..<length).map { _ in
            let index = Int.makeRandom(min: 0, max: allowedCharsStr.length - 1)
            var character = allowedCharsStr.character(at: index)
            return NSString(characters: &character, length: 1) as String
        }.joined(separator: "")
    }
}

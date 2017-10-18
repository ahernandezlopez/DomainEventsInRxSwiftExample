import Foundation

extension Int {
    public static func makeRandom() -> Int {
        return makeRandom(min: 1, max: 100)
    }
}

public extension Int {
    static func makeRandom(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}

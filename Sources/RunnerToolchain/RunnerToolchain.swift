import Foundation
public enum RunnerToolchain {
    public static func normalizedVersion(_ value: String) -> [Int]? {
        let parts = value.split(separator: ".", omittingEmptySubsequences: false)
        let parsed = parts.compactMap { Int($0) }
        guard !parts.isEmpty, parsed.count == parts.count, parsed.allSatisfy({ $0 >= 0 }) else { return nil }
        return parsed
    }
}

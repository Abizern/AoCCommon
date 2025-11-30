import Foundation
import Parsing

public extension String {
  /// Parses the string into an array of lines `([String])` separated by newline characters.
  ///
  /// For example, given an input:
  /// ```string
  /// """
  /// abc
  /// def
  /// """
  /// ```
  ///
  /// the parser returns
  ///```swift
  ///["abc", "def"]
  ///```
  ///
  /// - Returns: An array of `String`, one for each line in the input.
  /// - Throws: A parsing error if the input does not represent a sequence of
  ///   newline-separated lines.
  func lines() throws -> [String] {
    try LinesParser().parse(self)
  }

  /// Parses the string into an array of character `([[Character]])` lines.
  ///
  /// Each line is parsed as a sequence of characters up to (but not including)
  /// a newline. The entire input must consist solely of newline-separated lines.
  /// If the contents do not match this structure, the method throws a parsing
  /// error.
  ///
  /// for example, given an input:
  /// ```string
  /// """
  /// ab
  /// cd
  /// """
  /// ```
  ///
  /// the parser returns
  /// ```swift
  /// [['a', 'b'], ['c', 'd']]
  /// ```
  ///
  /// - Returns: A 2D array, where each inner array contains the characters of
  ///   one line.
  /// - Throws: A parsing error if the input is not a sequence of newline-
  ///   separated character lines.
  func characterLines() throws -> [[Character]] {
    try CharacterLinesParser().parse(self)
  }
}

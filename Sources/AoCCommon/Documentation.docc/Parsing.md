# Parsing

Common parsers for the input strings in Advent of Code problems

Parsing is mainly provided through the [swift-parsing](https://swiftpackageindex.com/pointfreeco/swift-parsing) libary.
This is re-exported so there is no need to declare the import at the call site.

The smaller parsers provided can be used to compose more custom parsers when needed, but more common inputs are parsed 
through extensions on `String`, and these should be preferred

## Topics

Can I put text in here 

### Number Parsers
- ``NumberPair``
- ``NumberPairs``
- ``NumberLine``
- ``NumberLines``

### Digit Parsers
- ``SingleDigitLineParser``
- ``SingleDigitLinesParser``

### Grid Parsers
- ``SingleDigitGridParser``

### Lines of Text
- ``LinesParser``
- ``CharacterLineParser``
- ``CharacterLinesParser``

### String extensions
- ``Swift/String/lines()``
- ``Swift/String/characterLines()``
- ``Swift/String/numberRanges()``


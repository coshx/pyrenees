public extension Int {
    var binaryString: String { return String(self, radix: 2) }
    var hexaString : String { return String(self, radix: 16) }
    var doubleValue : Double { return Double(self) }
}
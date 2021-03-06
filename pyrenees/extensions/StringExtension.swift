public extension String {
    var hexaToInt: Int { return Int(strtoul(self, nil, 16)) }
    var hexaToDouble: Double { return Double(strtoul(self, nil, 16)) }
    var hexaToBinary: String { return String(hexaToInt, radix: 2) }
    var decimalToHexa: String { return String(Int(self) ?? 0, radix: 16) }
    var decimalToBinary: String { return String(Int(self) ?? 0, radix: 2) }
    var binaryToInt: Int { return Int(strtoul(self, nil, 2)) }
    var binaryToDouble: Double { return Double(strtoul(self, nil, 2)) }
    var binaryToHexa: String { return String(binaryToInt, radix: 16) }
}
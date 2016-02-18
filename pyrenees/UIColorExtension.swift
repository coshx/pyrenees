public extension UIColor {
    public static func fromRGB(red: Int, green: Int, blue: Int) -> UIColor {
        return fromRGB(red, green: green, blue: blue, alpha: 1)
    }

    public static func fromRGB(red: Int, green: Int, blue: Int, alpha: Double) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha))
    }
}

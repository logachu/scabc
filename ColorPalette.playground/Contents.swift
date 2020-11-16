import Foundation

typealias ColorPalette = Set<CGColor>
    
extension CGColor {
    static func hex(red: Int, green: Int, blue: Int, alpha: Int) -> CGColor {
        let r = CGFloat(red) / CGFloat(0xFF)
        let g = CGFloat(green) / CGFloat(0xFF)
        let b = CGFloat(blue) / CGFloat(0xFF)
        let a = CGFloat(alpha) / CGFloat(0xFF)
        return CGColor(red: r, green: g, blue: b, alpha: a)
    }
}

let black = CGColor.black
let red = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
let green = CGColor(red: 0, green: 1, blue: 0, alpha: 1)
let blue = CGColor(red: 0, green: 0, blue: 1, alpha: 1)
let violet = CGColor.hex(red: 0x3C, green: 0x1B, blue: 0x6B, alpha: 0xFF)
let orange = CGColor.hex(red: 0xFF, green: 0x80, blue: 0x00, alpha: 0xff)
let yellow = CGColor.hex(red: 0xFF, green: 0xFF, blue: 0x00, alpha: 0xFF)
let cyan = CGColor.hex(red: 0x00, green: 0xFF, blue: 0xFF, alpha: 0xFF)
let magenta = CGColor.hex(red: 0xFF, green: 0x00, blue: 0xFF, alpha: 0xFF)
let brown = CGColor.hex(red: 0x80, green: 0x80, blue: 0x00, alpha: 0xFF)
let darkGreen = CGColor.hex(red: 0x40, green: 0x60, blue: 0x00, alpha: 0xFF)

let colorArray = [
    black, red, green, blue, violet, orange, yellow, cyan, magenta, brown, darkGreen
]

var scabcColors = Set<CGColor>(colorArray)
scabcColors.randomElement()
scabcColors.randomElement()
scabcColors.randomElement()
scabcColors.randomElement()
scabcColors.randomElement()
scabcColors.randomElement()
scabcColors.randomElement()
scabcColors.randomElement()
scabcColors.randomElement()

import UIKit

public struct SCABC {
    struct Square {
        let x: Int
        let y: Int
        let color: CGColor
    }
    
    let width:  Int // how many Squares wide
    let height: Int // how many Squares high
    var backgroundColor: CGColor
    var squares = [Square]()
    
    mutating func addSquare(x: Int, y: Int, color: CGColor) {
        squares.append(Square(x: x, y: y, color: color))
    }
}


public class SCABCView: UIView {
    public var painting: SCABC? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override func draw(_ rect: CGRect) {
        if let ctx = UIGraphicsGetCurrentContext(),
           let painting = painting {
            paint(painting, with: ctx, into: rect)
        }
    }
}


extension CGColor {
    static var random: CGColor {
        return CGColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1
        )
    }
}


func paint(_ painting: SCABC, with ctx: CGContext, into rect: CGRect) {
    ctx.setFillColor(painting.backgroundColor)
    ctx.fill(rect)
    
    let width = rect.size.width / CGFloat(painting.width)
    let height = rect.size.height / CGFloat(painting.height)
    
    painting.squares.forEach { square in
        ctx.setFillColor(square.color)
        ctx.fill(
            CGRect(
                x: CGFloat(square.x) * width,
                y: CGFloat(square.y) * height,
                width: width,
                height: height
            )
        )
    }
}

public typealias FillingFunction = (Double, Double) -> Double
public typealias DistributionFunction = (Double) -> Double
public func collage(width: UInt, height: UInt, background: CGColor, fillingFunction: @escaping FillingFunction) -> SCABC {
    let width = Int(width)
    let height = Int(height)
    
    /// predicate to determine if a square should be filled or not based on a random distribution
    let isFilled = P(fillingFunction, xRange: 0..<width, yRange: 0..<height)
    
    var collage = SCABC(width: width, height: height, backgroundColor: background)
    
    for x in 0..<width {
        for y in 0..<height {
            if isFilled(x, y) {
                collage.addSquare(x: x, y: y, color: scabcColors.randomElement()!)
            }
        }
    }
    
    return collage
}

public func barry1(width: UInt, height: UInt) -> SCABC {
    let width = Int(width)
    let height = Int(height)
    let halfWidth = Int(ceil(Double(width)/2.0))
    let halfHeight = Int(ceil(Double(height)/2.0))
    var barry = SCABC(width: width, height: height, backgroundColor: UIColor.black.cgColor)
    for y in 0..<halfHeight {
        for x in y..<halfWidth {
            let color = scabcColors.randomElement()!
            barry.addSquare(x: x, y: y, color: color)
            barry.addSquare(x: width-x-1, y: y, color: color)
            barry.addSquare(x: y, y: x, color: color)
            barry.addSquare(x: y, y: width-x-1, color: color)
            barry.addSquare(x: width-y-1, y: x, color: color)
            barry.addSquare(x: width-y-1, y: width-x-1, color: color)
            barry.addSquare(x: width-x-1, y: height-y-1, color: color)
            barry.addSquare(x: x, y: height-y-1, color: color)
        }
    }
    return barry
}

/// function shaped like a symmetrical mountain with height 1
func mountain(withSteepness steepness: Double, peakingAt peak: Double) -> DistributionFunction {
    return { x -> Double in
        1/(1 + pow(steepness * (x-peak),2))
    }
}

public func verticalRidge(withSteepness steepness: Double, peakingAt peak: Double) -> FillingFunction {
    let dist = mountain(withSteepness: steepness, peakingAt: peak)
    return { (x: Double,_) -> Double in
        dist(x)
    }
    
}




public func fiftyFifty(x: Double, y: Double) -> Double { 0.5 }

public func radial(steepness: Double) -> FillingFunction {
    let peak = mountain(withSteepness: steepness, peakingAt: 0)
    return { x,y in
        let x = 2*x - 1
        let y = 2*y - 1
        let radius = sqrt(x*x + y*y)
        return peak(radius)
    }
}

/// dist is a function from interval [0,1] to the same interval whose shape is a probability distribution
/// P returns a function that takes an Int on the interval [min,max] and returns true or false with probability
/// based on the shape of dist transformed to the same interval.
func P(_ dist: @escaping FillingFunction, xRange: Range<Int>, yRange: Range<Int>) -> (Int, Int) -> Bool {
    return { (x: Int, y: Int) -> Bool in
        let nx = Double(x - xRange.lowerBound) / Double(xRange.upperBound - xRange.lowerBound)
        let ny = Double(y - yRange.lowerBound) / Double(yRange.upperBound - yRange.lowerBound)
        let r = Double.random(in: 0...1)
        return dist(nx, ny) > r
    }
}


/**
 NOTES:
    `edge0 < x < edge1`
    ```
    func smoothstep(lowEdge: Double, x: Double, highEdge: Double) {
        let t = clamp((x - lowEdge) / (highEdge - lowEdge), 0, 1)
        return t*t * (3.0 - 2.0*t)
    }
    ```
 
 library has func clamped(to limits: ClosedRange<Bound>) -> ClosedRange<Bound>
 
 pointy = 1/(e^abs(x*sharpness))
 
 mountain = 1/(1+x^2)
 
 */

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

/// Palette guessed by observing Spectrum Colors Arranged by Chance VII
let black = CGColor(gray: 0, alpha: 1)
let white = CGColor(gray: 1, alpha: 1)
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

let scabColorArray = [
    black, red, green, blue, violet, orange, yellow, cyan, magenta, brown, darkGreen
]

let barryColorArray = [white, blue]

var scabcColors = Set<CGColor>(barryColorArray)

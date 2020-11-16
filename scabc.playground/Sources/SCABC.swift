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

public typealias DistributionFunction = (Double) -> Double

public func collage(width: UInt, height: UInt, background: CGColor, distribution: @escaping DistributionFunction) -> SCABC {
    let width = Int(width)
    let height = Int(height)
    
    /// predicate to determine if a square should be filled or not based on a random distribution
    let isFilled = P(distribution, min: 0, max: width)
    
    var collage = SCABC(width: width, height: height, backgroundColor: background)
    
    for x in 0..<width {
        for y in 0..<height {
            if isFilled(x) {
                collage.addSquare(x: x, y: y, color: CGColor.random)
            }
        }
    }
    
    return collage
}

/// function shaped like a symmetrical moutain with height 1 and peak at x=0.5
public func mountain(withSteepness steepness: Double) -> DistributionFunction {
    return { (x: Double) -> Double in
        1/(1 + pow(steepness * (x-0.5),2))
    }
}

public func fiftyFifty(_ x: Double) -> Double {
    0.5
}

/// dist is a function from interval [0,1] to the same interval whose shape is a probability distribution
/// P returns a function that takes an Int on the interval [min,max] and returns true or false with probability
/// based on the shape of dist transformed to the same interval.
func P(_ dist: @escaping DistributionFunction, min: Int, max: Int) -> (Int) -> Bool {
    return { (x: Int) -> Bool in
        let nx = Double(x - min) / Double(max - min)
        let r = Double.random(in: 0...1)
        return dist(nx) > r
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


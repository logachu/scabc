import UIKit
import PlaygroundSupport

PlaygroundPage.current.liveView = SCABC_I()

/**
 Artist: Ellsworth Kelly
 Title: Spectrum Colors Arranged by Chance I
 Date: 1951
 Medium:  Collage of coated and uncoated colored papers over graphite grid on two joined sheets of wove paper
 Dimensions: 19 11/16 x 39 1/4 inches (50 x 99.7 cm)
 NOTES: 40 squares wide by 20 tall, background is off-white paper
 */
func SCABC_I() -> UIView {
    let view = SCABCView(frame: CGRect(x: 0, y: 0, width: 600, height: 300))
    let cream = CGColor(red: 1, green: 1, blue: 0.95, alpha: 1)
    view.painting = collage(width: 40, height: 20, background: cream, distribution: mountain(withSteepness: 4))
    return view
}

/**
 Artist: Ellsworth Kelly
 Title: Spectrum Colors Arranged by Chance II
 Date: 1951
 
 Medium: Cut-and-pasted color-coated paper and pencil on four sheets of paper
 Dimensions: 38 1/4 x 38 1/4" (97.2 x 97.2 cm)
 NOTES: four square sheets of paper arranged in a square each with 19x19 squares pasted on.  So 38x38 squares total
 */
func SCABC_II() -> UIView {
    let view = SCABCView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
    let black = CGColor(gray: 0, alpha: 1)
    view.painting = collage(width: 38, height: 38, background: black, distribution: fiftyFifty)
    return view
}

/**
 Artist: Ellsworth Kelly
 Title: Spectrum Colors Arranged by Chance III
 Date: 1951
 
 Medium: Cut-and-pasted color-coated paper on paper with light grid lines in graphite pencil
 Dimensions: 39" x 39"
 NOTES: one yellowed piece of paper 19x19 grid squares pasted on. So 38x38 squares total. Squares on outer
 border are all empty so its sort of 36x36
 */
// TOOD: func SCABC_III() -> VSView {

/// According to https://azprojectsblog.wordpress.com/2015/09/27/the-aesthetics-of-chance-ellsworth-kelly/
/// 18 different colors of paper were used.

/// SCABC VII https://i1.wp.com/socks-studio.com/img/blog/ellsworth-kelly-scabc-vii.jpg
func SCABC_VII() -> UIView {
    let view = SCABCView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
    let white = CGColor(gray: 1, alpha: 1) // Doesn't show because all squares are covered
    view.painting = collage(width: 38, height: 38, background: white, distribution: { _ in 1.0 })
    return view
}


class SCABCView: UIView {
    var painting: SCABC? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if let ctx = UIGraphicsGetCurrentContext(),
           let painting = painting {
            paint(painting, with: ctx, into: rect)
        }
    }
}

struct SCABC {
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

extension CGColor {
    static var random: CGColor {
        return CGColor(red: CGFloat.random(in: 0...1),
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

typealias DistributionFunction = (Double) -> Double

func collage(width: UInt, height: UInt, background: CGColor, distribution: @escaping DistributionFunction) -> SCABC {
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


/// function shaped like a symmetrical moutain with height 1 and peak at x=0.5
func mountain(withSteepness steepness: Double) -> DistributionFunction {
    return { (x: Double) -> Double in
        1/(1 + pow(steepness * (x-0.5),2))
    }
}

func fiftyFifty(_ x: Double) -> Double {
    0.5
}

/**
 func smoothstep(edg0 < x < edge1) {
 t = clamp((x-edge0) / (edge1 - edge0), 0, 1)
 return t*t * (3.0 - 2.0*t)
 }
 NOTE: func clamped(to limits: ClosedRange<Bound>) -> ClosedRange<Bound>
 
 pointy = 1/(e^abs(x*sharpness))
 
 mountain = 1/(1+x^2)
 
 */


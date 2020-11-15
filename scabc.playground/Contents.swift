//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class SCABCView: UIView {
    var painting: SCABC? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { fatalError() }
        guard let painting = painting else { return }

        ctx.setFillColor(painting.backgroundColor.cgColor)
        ctx.fill(rect)
        
        let width = rect.size.width / CGFloat(painting.width)
        let height = rect.size.height / CGFloat(painting.height)
        
        painting.squares.forEach { square in
            let rect = CGRect(
                x: CGFloat(square.x) * width,
                y: CGFloat(square.y) * height,
                width: width,
                height: height
            )
            ctx.setFillColor(square.color)
            ctx.fill(rect)
        }
    }
}

struct Square {
    let x: Int
    let y: Int
    let color: CGColor
}


struct SCABC {
    let width:  Int // how many Squares wide
    let height: Int // how many Squares high
    var backgroundColor: UIColor
    var squares = [Square]()

    mutating func addSquare(x: Int, y: Int, color: UIColor) {
        squares.append(Square(x: x, y: y, color: color.cgColor))
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(hue: CGFloat.random(in: 0...1),
                       saturation: 1.0,
                       brightness: CGFloat.random(in: 0.6...1.0),
                       alpha: 1
        )
    }
}


func collage() -> SCABC {
    let cream = UIColor(red: 1, green: 1, blue: 0.95, alpha: 1)
    let width = 20
    let height = 20
    let numberOfSquares = 300
    
    var collage = SCABC(width: width, height: height, backgroundColor: cream)
    
    let points = (1...numberOfSquares).map { _ -> (x: Int, y: Int) in
        (x: Int.random(in: 0..<width), y: Int.random(in: 0..<height))
    }
    
    points.forEach { (point) in
        let randColor = UIColor.random
        collage.addSquare(x: point.x, y: point.y, color: randColor)
    }
    return collage
}

let view = SCABCView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
view.painting = collage()

PlaygroundPage.current.liveView = view

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

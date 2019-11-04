/**
 * GOAL:
 *    To determine if multiple calls to [NSLayoutConstraint addConstraints:] lead to a duplication of NSLayoutConstraint
 *    instances associated with their respective views.
 *
 * FINDINGS: 
 *    Multiple calls to [NSLayoutConstraint addConstraints:] does NOT lead to a duplication of NSLayoutConstraint instances
 *    associated with their respective views.
 *
 * Version: Apple Swift version 5.1.2 (swiftlang-1100.0.278 clang-1100.0.33.9)
 * Updated Date: 11-04-2019
 * Created Date: 4-28-2016
 * Author: Grant Sheldon
 */

import UIKit

let aView = UIView()
let bView = UIView()

let views = [ "aView": aView, "bView": bView ]
bView.addSubview(aView)
aView.translatesAutoresizingMaskIntoConstraints = false
bView.translatesAutoresizingMaskIntoConstraints = false

let constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[aView]|", options: [], metrics: nil, views: views)

// NOTE: Rm'ing both of these 2 calls has the expected effect of dropping the constraint count on `bView` to 0.
bView.addConstraints(constraints)
bView.addConstraints(constraints) // Does NOT duplicate constraints

/*
 * Prints 2 constraints corresponding to the visual formatting string activated above. Specifically:
 *
 * <NSLayoutConstraint:0x7fdf19d18350 H:|-(0)-[UIView:0x7fdf19e17d50]   (Names: '|':UIView:0x7fdf19d11a70 )>
 * <NSLayoutConstraint:0x7fdf19d188c0 H:[UIView:0x7fdf19e17d50]-(0)-|   (Names: '|':UIView:0x7fdf19d11a70 )>
 */
for constraint in bView.constraints {
  print(constraint)
}

// Prints 0 constraints. There are no constraints attached to the child view.
for constraint in aView.constraints {
  print(constraint)
}

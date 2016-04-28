/**
 * GOAL:
 *    To determine if multiple calls to NSLayoutConstraint.activateConstraints() lead to a duplication of NSLayoutConstraint
 *    instances associated with their respective views.
 *
 * FINDINGS: 
 *    Multiple calls to NSLayoutConstraint.activateConstraints() does NOT lead to a duplication of NSLayoutConstraint instances
 *    associated with their respective views.
 *
 * Version: Apple Swift version 2.2 (swiftlang-703.0.18.5 clang-703.0.31)
 * Date:    4-28-2016
 * Author:  Grant Sheldon
 */

import UIKit

let aView = UIView()
let bView = UIView()

let views = [ "aView": aView, "bView": bView ]
bView.addSubview(aView)
aView.translatesAutoresizingMaskIntoConstraints = false
bView.translatesAutoresizingMaskIntoConstraints = false

let constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[aView]|", options: [], metrics: nil, views: views)

// NOTE: Rm'ing both of these 2 calls has the expected effect of dropping the constraint count on `bView` to 0.
NSLayoutConstraint.activateConstraints(constraints)
NSLayoutConstraint.activateConstraints(constraints) // Does NOT duplicate constraints

/*
 * Prints 2 constraints corresponding to the visual formatting string activated above. Specifically:
 *
 * <NSLayoutConstraint:0x7f8fa0430180 H:|-(0)-[UIView:0x7f8fa0427900]   (Names: '|':UIView:0x7f8fa042e5c0 )>
 * <NSLayoutConstraint:0x7f8fa04303f0 H:[UIView:0x7f8fa0427900]-(0)-|   (Names: '|':UIView:0x7f8fa042e5c0 )>
 */
for constraint in bView.constraints {
  print(constraint)
}


// Prints 0 constraints. There are no constraints attached to the child view.
for constraint in aView.constraints {
  print(constraint)
}

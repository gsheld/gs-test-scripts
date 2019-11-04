/**
* GOAL:
*   Determine how many calls to `layoutSubviews` are made inside a view nested inside two `UIStackView`.
*
* FINDINGS:
*   `layoutSubviews` is called twice for views nested inside two `UIStackView`. It appears `UIStackView` does two layout passes before its children
*   are fully layed out.
*
* Version: Apple Swift version 5.1.2 (swiftlang-1100.0.278 clang-1100.0.33.9)
* Updated Date: 11-04-2019
* Created Date: 11-04-2019
* Author: Grant Sheldon
*/

import PlaygroundSupport
import UIKit

class ExampleLabel: UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        print("ExampleLabel(\(text!)): layoutSubviews called")
        print("ExampleLabel(\(text!)) size: \(frame.size)")
        print("ExampleLabel(\(text!)) preferred size: \(systemLayoutSizeFitting(.zero))\n")
    }
}

class ExampleStackView: UIStackView {
    override func layoutSubviews() {
        super.layoutSubviews()
        print("ExampleStackView(\(accessibilityIdentifier!)): layoutSubviews called")
        print("ExampleStackView(\(accessibilityIdentifier!)) size: \(frame.size)\n")
    }
}

class ExampleViewController: UIViewController {

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews called\n")
    }

    func makeLabel(text: String, borderColor: UIColor) -> UILabel {
        let label = ExampleLabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = borderColor.cgColor
        // Preferred size is dynamic when this constraint is not set because the intrinsic
        // content width of the labels are allowed to fill their container without impediment.
        // label.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return label
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let labelOne = makeLabel(text: "One", borderColor: .green)
        let labelTwo = makeLabel(text: "Two", borderColor: .red)
        let labelThree = makeLabel(text: "Three", borderColor: .blue)
        let labelFour = makeLabel(text: "Four", borderColor: .orange)

        let innerStackViewOne = ExampleStackView(arrangedSubviews: [labelOne, labelTwo])
        innerStackViewOne.distribution = .fillEqually
        innerStackViewOne.accessibilityIdentifier = "innerStackViewOne"

        let innerStackViewTwo = ExampleStackView(arrangedSubviews: [labelThree, labelFour])
        innerStackViewTwo.distribution = .fillEqually
        innerStackViewTwo.accessibilityIdentifier = "innerStackViewTwo"

        let outerStackView = ExampleStackView(arrangedSubviews: [innerStackViewOne, innerStackViewTwo])
        outerStackView.distribution = .fillEqually
        outerStackView.accessibilityIdentifier = "outerStackView"

        let views = [
            "labelOne": labelOne,
            "labelTwo": labelTwo,
            "labelThree": labelThree,
            "labelFour": labelFour,
            "innerStackViewOne": innerStackViewOne,
            "innerStackViewTwo": innerStackViewTwo,
            "outerStackView": outerStackView,
        ]

        view.addSubview(outerStackView)
        views.values.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        ["H:|[outerStackView]|", "V:|[outerStackView]"]
            .map { NSLayoutConstraint.constraints(withVisualFormat: $0, options: [], metrics: nil, views: views) }
            .flatMap { $0 }
            .forEach { $0.isActive = true }
    }
}

let viewController = ExampleViewController()
PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true

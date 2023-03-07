//
//  ViewController.swift
//  UIKit_3
//
//  Created by Roman Korobskoy on 07.03.2023.
//

import UIKit

class ViewController: UIViewController {
    private lazy var roundedView = UIView()
    private lazy var slider = UISlider()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupSubviews()
    }
}

private extension ViewController {
    @objc
    func sliderDidMove(_ sender: UISlider) {
        let currentValue = CGFloat(sender.value)

        let scale = 1 + (CGFloat(sender.value) / CGFloat(sender.maximumValue)) * 0.5
        let angle = CGFloat.pi / 2
        let rotationAngle = (CGFloat(sender.value) / CGFloat(sender.maximumValue)) * angle

        let transform = CGAffineTransform(
            translationX: currentValue + view.layoutMargins.left,
            y: 0
        )
            .scaledBy(x: scale, y: scale)
            .rotated(by: rotationAngle)

        roundedView.transform = transform

        let viewWidth = view.bounds.width - view.layoutMargins.right - view.layoutMargins.left
        let roundedViewWidth = roundedView.frame.size.width
        let centerView = roundedViewWidth / 2
        let value = (viewWidth * currentValue * (1.0 - roundedViewWidth / viewWidth)) + centerView

        roundedView.center.x = value
    }

    @objc
    func sliderDidEndEditing(_ sender: UISlider) {
//    func sliderDidEndEditing(_ sender: UITapGestureRecognizer) {
        guard slider.value != slider.maximumValue
//              sender.state == .ended
        else { return }
        let sliderValue = CGFloat(slider.maximumValue)

//        let viewWidth = view.bounds.width
//        let roundedViewWidth = roundedView.frame.size.width
//        let centerView = roundedViewWidth / 2
//        let value = (viewWidth * sliderValue * (1.0 - roundedViewWidth / viewWidth)) + centerView
//
//        roundedView.center.x = value
        UIView.animate(withDuration: 0.2) {
            self.slider.value = 1.0
            self.slider.layoutIfNeeded()
            self.roundedView.layoutIfNeeded()
        }
    }
}

private extension ViewController {
    func setupSubviews() {
        roundedView.backgroundColor = .systemBlue
        roundedView.layer.cornerRadius = 10

        view.addSubview(roundedView)
        view.addSubview(slider)

        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        setConstraints()
        slider.addTarget(self, action: #selector(sliderDidMove(_:)), for: .valueChanged)
//        slider.addTarget(self, action: #selector(sliderDidEndEditing(_:)), for: )

//        let panGestureRecognizer = UITapGestureRecognizer()
//        panGestureRecognizer.addTarget(self, action: #selector(sliderDidEndEditing(_:)))
//        slider.addGestureRecognizer(panGestureRecognizer)
    }

    func setConstraints() {
        let marginsGuide = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            roundedView.topAnchor.constraint(equalTo: marginsGuide.topAnchor, constant: 20),
            roundedView.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
            roundedView.heightAnchor.constraint(equalToConstant: 75),
            roundedView.widthAnchor.constraint(equalTo: roundedView.heightAnchor),

            slider.topAnchor.constraint(equalTo: roundedView.bottomAnchor, constant: 50),
            slider.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),
        ])
    }
}

// MARK: - Previews
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {


    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }

    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> ViewController {
        viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}
#endif

struct BestInClassPreviews_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            // Return whatever controller you want to preview
            let vc = ViewController()
            return vc
        }
    }
}

//
//  ScaleView.swift
//  RulerScale
//
//  Created by BCL-Device-11 on 23/10/22.
//

import UIKit

class ScaleView: UIView {
    
    private let handleView = HandleView()
    private let currentTimeLabel = UILabel()
    private let timeImageView = UIImageView()
   
    public let handleBarWidth = 8.0
    public let handleBarHeight = 30.0
    public let totalNumberOfPoint = 40.0
    public let floatingScalePointHeight = 4.0
    public let integerScalePointHeight = 15.0
    
    private var scalePadding = 4.0
    private var leftConstraint: NSLayoutConstraint?
    private var currentLeftConstraint: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDragView ()
        setupSpeedPointView()
        setupGestures()
    }
    
    override func draw(_ rect: CGRect) {
        drawRulerScale()
    }
    
    func setupDragView () {
        handleView.backgroundColor = .black
        handleView.layer.cornerRadius = 4
        handleView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(handleView)
        handleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        handleView.heightAnchor.constraint(equalToConstant: handleBarHeight).isActive = true
        handleView.widthAnchor.constraint(equalToConstant: handleBarWidth).isActive = true
        leftConstraint = handleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
    }
    
    func setupGestures() {
        let leftPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture))
        handleView.addGestureRecognizer(leftPanGestureRecognizer)
    }
    
    func setupSpeedPointView() {
        timeImageView.translatesAutoresizingMaskIntoConstraints = false
        timeImageView.image = UIImage(named: "timeFrame")
        timeImageView.contentMode = .scaleToFill
        addSubview(timeImageView)
        
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.text = "0x"
        currentTimeLabel.font = UIFont.systemFont(ofSize: 9, weight: .medium)
        currentTimeLabel.textColor = .black
        timeImageView.addSubview(currentTimeLabel)
        
        timeImageView.topAnchor.constraint(equalTo: handleView.topAnchor, constant: -25).isActive = true
        timeImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        timeImageView.heightAnchor.constraint(equalToConstant: 22) .isActive = true
        timeImageView.centerXAnchor.constraint(equalTo: handleView.centerXAnchor).isActive = true
        currentTimeLabel.centerXAnchor.constraint(equalTo: timeImageView.centerXAnchor).isActive = true
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let _ = gestureRecognizer.view, let superView = gestureRecognizer.view?.superview else { return }
        switch gestureRecognizer.state {
        case .began:
            currentLeftConstraint = leftConstraint!.constant
                updateSelectedTime()
        case .changed:
            let translation = gestureRecognizer.translation(in: superView)
                updateLeftConstraint(with: translation)
            layoutIfNeeded()
            updateSelectedTime()
        case .cancelled, .ended, .failed:
            updateSelectedTime()
        default: break
        }
    }
    
    private func updateLeftConstraint(with translation: CGPoint) {
        let maxConstraint = max(self.bounds.width - self.handleView.bounds.width, 0)
        let newConstraint = min(max(0, currentLeftConstraint + translation.x), maxConstraint)
        leftConstraint?.isActive = true
        leftConstraint?.constant = newConstraint
    }
    
    private func updateSelectedTime() {
        
        let handleBarPosition = handleView.frame.origin.x
        let scaleWidth = self.bounds.width - scalePadding * 2
        let scaleFactor = totalNumberOfPoint / 10.0
        let currentPoint = (handleBarPosition / scaleWidth) * scaleFactor
        let stringNumber = String(format: "%.1f",currentPoint)
        let speed = (stringNumber as NSString).floatValue
        currentTimeLabel.text = "\(speed)x"
        print("Speed : ",speed)
    }
    
    func drawRulerScale() {
        
        let lines = UIBezierPath()
        let spaceBetweenTwoPoints:Double = ((self.bounds.width - scalePadding * 2) / totalNumberOfPoint) * 10
        
        for i in 0...Int(totalNumberOfPoint) {
            
            let currentValue:Double = Double(i) / 10.0
            let isInteger = floor(currentValue) == currentValue
            let height = (isInteger) ? integerScalePointHeight : floatingScalePointHeight
            let topSpace =  (self.bounds.height - height)/2.0
            
            let oneLine = UIBezierPath()
            oneLine.move(to: CGPoint(x: currentValue*spaceBetweenTwoPoints + scalePadding, y: topSpace))
            oneLine.addLine(to: CGPoint(x: currentValue*spaceBetweenTwoPoints + scalePadding, y: height + topSpace))
            lines.append(oneLine)
            
            if(isInteger)
            {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 21))
                label.center = CGPoint(x: currentValue*spaceBetweenTwoPoints + scalePadding, y: topSpace + height + 15)
                label.font = UIFont.systemFont(ofSize: 9)
                label.textAlignment = .center
                label.text = "\(Int(currentValue))x"
                self.addSubview(label)
            }
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = lines.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1.5
        self.layer.addSublayer(shapeLayer)
    }
}

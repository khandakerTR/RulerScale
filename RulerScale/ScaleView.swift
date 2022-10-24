//
//  ScaleView.swift
//  RulerScale
//
//  Created by BCL-Device-11 on 23/10/22.
//

import UIKit

class ScaleView: UIView {
    
    let dragView = UIView()
    private var leftConstraint: NSLayoutConstraint?
    private var currentLeftConstraint: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDragView ()
    }
    
    override func draw(_ rect: CGRect) {
        drawRulerScale()
        setupDragView ()
        setupGestures()
    }
    
    func setupDragView () {
        dragView.backgroundColor = .black
        dragView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dragView)
        dragView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        dragView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dragView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        leftConstraint = dragView.leftAnchor.constraint(equalTo: leftAnchor, constant: -8)
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let _ = gestureRecognizer.view, let superView = gestureRecognizer.view?.superview else { return }
        switch gestureRecognizer.state {
        case .began:
                currentLeftConstraint = leftConstraint!.constant
                updateSelectedTime(stoppedMoving: false)
        case .changed:
            let translation = gestureRecognizer.translation(in: superView)
                updateLeftConstraint(with: translation)
            layoutIfNeeded()
            updateSelectedTime(stoppedMoving: false)
        case .cancelled, .ended, .failed:
            updateSelectedTime(stoppedMoving: true)
        default: break
        }
    }
    
    private func updateLeftConstraint(with translation: CGPoint) {
        let maxConstraint = max(self.bounds.width - self.dragView.bounds.width, 0)
        let newConstraint = min(max(0, currentLeftConstraint + translation.x), maxConstraint)
        leftConstraint?.isActive = true
        leftConstraint?.constant = newConstraint
    }
    
    private func updateSelectedTime(stoppedMoving: Bool) {
        if stoppedMoving {
//            print("Stoped  : ",dragView.frame)
            let width = dragView.bounds.width/2.0
            
            print(String(format: "a float number: %.1f",((dragView.frame.origin.x + width / 2) / (self.bounds.width - 8) * 4.0)))
            //delegate?.positionBarStoppedMoving(playerTime)
        } else {
            //delegate?.didChangePositionBar(playerTime)
//            print("Moving  : ",dragView.frame)
        }
    }
    
    func setupGestures() {
        let leftPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture))
        dragView.addGestureRecognizer(leftPanGestureRecognizer)
    }
    
    func drawRulerScale() {
        
        let totalNumberOfPoint = 40.0
        let interItemSpcae:Double = ((self.bounds.width - 8) / totalNumberOfPoint) * 10
        let lines = UIBezierPath()

        for i in 0...40 {
            
            let temp:Double = Double(i) / 10.0
            let isInteger = floor(temp) == temp
            let height = (isInteger) ? 15.0 : 5.0
            let space =  (self.bounds.height - height)/2.0
            let oneLine = UIBezierPath(roundedRect: .null, cornerRadius: 6)
            
            oneLine.move(to: CGPoint(x: temp*interItemSpcae + 4, y: space))
            oneLine.addLine(to: CGPoint(x: temp*interItemSpcae + 4, y: height + space))
            lines.append(oneLine)
            if(isInteger)
            {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 21))
                label.center = CGPoint(x: temp*interItemSpcae, y: space + height+15)
                label.font = UIFont.systemFont(ofSize: 9)
                label.textAlignment = .center
                label.text = "\(Int(temp))x"
                self.addSubview(label)
            }
        }

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = lines.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1

        // ADD LINES IN LAYER
        self.layer.addSublayer(shapeLayer)
    }

}

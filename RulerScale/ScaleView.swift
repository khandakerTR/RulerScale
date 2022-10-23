//
//  ScaleView.swift
//  RulerScale
//
//  Created by BCL-Device-11 on 23/10/22.
//

import UIKit

class ScaleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        drawRulerScale()
    }
    
    func drawRulerScale() {
        
        let totalNumberOfPoint = 40.0
        let interItemSpcae:Double = ((self.bounds.width) / totalNumberOfPoint) * 10
        let lines = UIBezierPath()

        for i in 0...40 {
            
            let temp:Double = Double(i) / 10.0
            let isInteger = floor(temp) == temp
//
            let height = (isInteger) ? 15.0 : 5.0
            let space =  (self.bounds.height - height)/2.0
            let oneLine = UIBezierPath()

     
            oneLine.move(to: CGPoint(x: temp*interItemSpcae, y: space))
            oneLine.addLine(to: CGPoint(x: temp*interItemSpcae, y: height + space))
            
            //oneLine.move(to: CGPoint(x: temp*interItemSpcae, y: (self.bounds.height - spcae) / 2.0))
            //oneLine.addLine(to: CGPoint(x: temp*interItemSpcae, y: height))
            print("oneline Move: ",CGPoint(x: temp*interItemSpcae, y:  space))
            print("oneline Add : ",CGPoint(x: temp*interItemSpcae, y: space + height))
            
            lines.append(oneLine)
//
             //INDICATOR TEXT
//            if(isInteger)
//            {
//                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 21))
//                label.center = CGPoint(x: temp*interItemSpcae, y: height+15)
//                label.font = UIFont.systemFont(ofSize: 9)
//                label.textAlignment = .center
//                label.text = "\(Int(temp))x"
//                self.addSubview(label)
//            }
        }

        // DESIGN LINES IN LAYER#imageLiteral(resourceName: "simulator_screenshot_9318CD10-508C-4EEC-B8FA-0C49886F3119.png")
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = lines.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2

        // ADD LINES IN LAYER
        self.layer.addSublayer(shapeLayer)
    }

}

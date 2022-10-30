//
//  ViewController.swift
//  RulerScale
//
//  Created by BCL-Device-11 on 23/10/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scaleRulerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = loadViewFromNib()
        view.frame = scaleRulerView.bounds
        view.totalNumberOfPoint = 40
        scaleRulerView.addSubview(view)
    }
    
    func loadViewFromNib() -> ScaleView {
        let nib = UINib(nibName: "ScaleView", bundle: Bundle(for: type(of: self)))
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! ScaleView
        return view
    }

}


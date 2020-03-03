//
//  AstrolingoView.swift
//  AstroLingo
//
//  Created by B.N. Ogum on 03/03/2020.
//  Copyright © 2020 B.N. Ogum. All rights reserved.
//

import Foundation
import UIKit

class AstrolingoView: UIView {
    
//    @IBOutlet weak var fallingWords: UIButton!
//    var game = AstroLingo()
    
    var fallingWords = UIButton()
    
    
    
    
    
    
    func fall(_ sender: UIButton) {
//        print("animating")
        UIView.animate(withDuration: 2, delay: 0.2, options: .curveEaseIn, animations: {
            sender.frame.origin = CGPoint.init(x: sender.frame.origin.x, y:         self.bounds.maxY)//        self.frame.maxY)
            
        }) { (true) in
            sender.frame.origin = CGPoint.init(x: sender.frame.origin.x, y: 0)
        }
        print("animated")
    }
    
    func addAsteroid(withWord addWord: String)  {
      
        
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("Test Button", for: .normal )
               
        
        fall(button)
        fall(button)
//        button.addTarget(self, action: #selector(fall(_ :)), for: .touchUpInside)
        
        self.addSubview(button)

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let _ = loadViewFromNib()
        
        
        addAsteroid(withWord: "Hello")
        
    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: "GameView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask  =    [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        return view
    }
      
    
}

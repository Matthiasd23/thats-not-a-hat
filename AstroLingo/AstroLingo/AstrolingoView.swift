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
    
    var fallingWords : [UIButton?] = []
    
    
    
    
    
    
    
    func fall(_ sender: UIButton) {
//        print("animating")
        UIView.animate(withDuration: 3, delay: 0.2, options: .curveEaseIn, animations: {
            sender.frame.origin = CGPoint.init(x: sender.frame.origin.x, y:         self.bounds.maxY-sender.frame.maxY)//        self.frame.maxY)
            
        }) { (true) in
//            sender.frame.origin = CGPoint.init(x: sender.frame.origin.x, y: 0)
//            delete the button after it has completed]
            
            
//            self.fallingWords.removeAll(where: {$0?.currentTitle==sender.currentTitle})
//            sender.removeFromSuperview()
            
            self.destroyAsteroid(sender)
        }
    }
    
    private func generateAsteroid(withWord text: String) -> UIButton {//TODO: [Fill in text in asteroid from fallingWords]
        let asteroid = UIButton()
        asteroid.backgroundColor = .green
        asteroid.setTitle(text, for: .normal)
        asteroid.frame.size = CGSize.init(width: 150, height: 50)
        
        
        asteroid.frame.origin = CGPoint.init(x: Int.random(in: 0...(Int(self.bounds.maxX))-Int(asteroid.frame.size.width)), y: 0)
        
        
        asteroid.titleLabel?.numberOfLines=1
        asteroid.titleLabel?.adjustsFontSizeToFitWidth = true
        asteroid.titleLabel?.minimumScaleFactor = 0.01
//        asteroid.titleLabel?.lineBreakMode =
        
        
        fall(asteroid)
        
        self.addSubview(asteroid)
        return asteroid
    }
    
    func addAsteroid(withWord addWord: String)  {
        fallingWords.append(generateAsteroid(withWord: addWord))
    }
    
    func destroyAsteroid(_ sender: UIButton) -> Bool { //TODO: [Ensure that 2 asteroids do not have the same word on them]
        //return true if an asteroid was destroyed
        //false if asteroid could not be found => Incorrect word was entered
        if fallingWords.contains(sender){
            UIView.animate(withDuration: 0.8, animations: {
                sender.backgroundColor = .red
                sender.alpha = 0.2
            }) { (_) in
                self.fallingWords.removeAll(where: {$0?.currentTitle==sender.currentTitle})
                sender.removeFromSuperview()
            }
            
            return true
        }
        
        return false
       
    }
    
    private func asteroid(withWord text: String) -> UIButton?    {
        for word in fallingWords    {
            if word?.currentTitle == text {
                return word
            }
        }
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let _ = loadViewFromNib()
        
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

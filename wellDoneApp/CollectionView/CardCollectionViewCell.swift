//
//  CardCollectionViewCell.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 23/07/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit


final class CardCollectionViewCell: UICollectionViewCell {
    
    var disabledAnimation:Bool? = false

    
    @IBOutlet weak var cardContentView: CardContentView!
    
    func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        if(disabledAnimation! == true){ return }
        if isHighlighted {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [UIView.AnimationOptions.beginFromCurrentState], animations: {
                self.transform = CGAffineTransform.identity.scaledBy(x: kHighlightedFactor, y: kHighlightedFactor)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [UIView.AnimationOptions.beginFromCurrentState], animations: {
                self.transform = .identity
            }, completion: completion)
        }
        
        func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
            if disabledAnimation! { return }
            if isHighlighted {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [UIView.AnimationOptions.beginFromCurrentState], animations: {
                    self.transform = CGAffineTransform.identity.scaledBy(x: kHighlightedFactor, y: kHighlightedFactor)
                }, completion: completion)
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [UIView.AnimationOptions.beginFromCurrentState], animations: {
                    self.transform = .identity
                }, completion: completion)
            }
        }
        
        func resetTransform() {
            self.transform = .identity
        }
        
        func awakeFromNib() {
            cardContentView.layer.cornerRadius = 16
            cardContentView.layer.masksToBounds = true
            self.backgroundColor = .clear
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = .init(width: 0, height: 4)
            self.layer.shadowRadius = 12
        }
        
        func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.animate(isHighlighted: true)
        }
        
        func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            self.animate(isHighlighted: false)
        }
        
        func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesCancelled(touches, with: event)
            self.animate(isHighlighted: false)
        }
    }
    
    func resetTransform() {
        self.transform = .identity
    }
    
    override func awakeFromNib() {
        cardContentView.layer.cornerRadius = 16
        cardContentView.layer.masksToBounds = true
        self.backgroundColor = .clear
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = .init(width: 0, height: 4)
        self.layer.shadowRadius = 12
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.animate(isHighlighted: false)
    }
}

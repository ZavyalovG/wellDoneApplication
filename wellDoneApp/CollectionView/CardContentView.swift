//
//  CardContentView.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 23/07/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//
import UIKit

@IBDesignable class CardContentView: UIView{
    
    var eventModel: EventModel?{
        didSet{
            if(eventModel != nil){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM"
            title.text = eventModel?.title
            dLabel.text = dateFormatter.string(from: (eventModel?.startingDate)!)
            
            indicatorView.asCircle()
            indicatorView.image = eventModel?.image
                

                
            }
        }
        
    }
    
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dLabel: UILabel!
    
    @IBOutlet weak var indicatorView: UIImageView!
    
    @IBOutlet weak var imageToTopAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var imageToLeadingAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var imageToTrailingAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var imageToBottomAnchor: NSLayoutConstraint!
    
    
    @IBInspectable var backgroundImage: UIImage? {
        get {
            return self.indicatorView.image
        }
        
        set(image) {
            self.indicatorView.image = image
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
        commonSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        commonSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonSetup()
    }
    
    private func commonSetup() {
        indicatorView.contentMode = .center
        fontState(isHighlighted: false)
    }
    
    func fontState(isHighlighted: Bool) {
        if isHighlighted {
            title.font = UIFont.systemFont(ofSize: 22 * kHighlightedFactor, weight: .bold)
            dLabel.font = UIFont.systemFont(ofSize: 18 * kHighlightedFactor, weight: .semibold)
        } else {
            title.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            
            dLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
    }
    
}

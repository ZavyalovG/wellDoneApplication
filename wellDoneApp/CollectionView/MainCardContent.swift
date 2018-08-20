//
//  MainCardContent.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 14/08/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit


class MainCardContent: UIView{

    var karmaModel: ProjectKarmaModel?{
        didSet{
            if(karmaModel != nil){
                if(karmaModel?.value == .well){
                    smile.text = "👍"
                }else if(karmaModel?.value == .perfect){
                    smile.text = "👑"
                }else if(karmaModel?.value == .okey){
                    smile.text = "👌"
                }else if(karmaModel?.value == .bad){
                    smile.text = "💩"
                }
            }
        }
    }
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var small: UILabel!
    @IBOutlet weak var smile: UILabel!
    

  
    
    
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
        fontState(isHighlighted: false)
    }
    
    func fontState(isHighlighted: Bool) {
        if isHighlighted {
            title.font = UIFont.systemFont(ofSize: 22 * kHighlightedFactor, weight: .bold)
            small.font = UIFont.systemFont(ofSize: 15 * kHighlightedFactor, weight: .semibold)
            smile.font = UIFont.systemFont(ofSize: 31 * kHighlightedFactor, weight: .regular)
        } else {
            title.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            small.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            smile.font = UIFont.systemFont(ofSize: 31, weight: .regular)

        }
    }
    
}

//
//  UndoneDetailedViewController.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 18/08/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class UndoneDetailedViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var progressDate: UIProgressView!
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var indicImage: UIImageView!
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    weak var delegateUpdate: UpdateAllItems?

    
    var counterForProgressView: Float = 0 {
        didSet{
            let fractionalProgress = Float(counterForProgressView)
            
            print(fractionalProgress)
            let animated = counterForProgressView != 0
            
            
            progressDate.setProgress(fractionalProgress, animated: true)
        }
    }
    
    var cardViewModel: EventModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressDate.setProgress(0, animated: true)
        
        
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd MMMM"
        
        titleLabel.text = cardViewModel?.title
        dateLabel.text = dateFormatter2.string(from: cardViewModel?.endingDate ?? Date())
        textView.text = cardViewModel?.text
        indicImage.asCircle()
        indicImage.image = cardViewModel?.image
        
        buttonDone.layer.cornerRadius = 5
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        
        let lStart = dateFormatter.string(from: cardViewModel?.startingDate ?? Date())
        let lEnd = dateFormatter.string(from: cardViewModel?.endingDate ?? Date())
        
        startDateLabel.text = lStart
        endDateLabel.text = lEnd
        
        
        let calendar = NSCalendar.current
        
        
        
        let dateStart = calendar.startOfDay(for: (cardViewModel?.startingDate ?? Date()))
        let dateEnd = calendar.startOfDay(for: (cardViewModel?.endingDate ?? Date()))
        let dateNow = calendar.startOfDay(for: NSDate() as Date)
        
        let components1 = calendar.dateComponents([.day], from: dateStart, to: dateEnd)
        let components2 = calendar.dateComponents([.day], from: dateStart, to: dateNow)
        
        let a = Float(components1.day!)
        let b = Float(components2.day!)
        
        print(b)
        print(a)
        
        counterForProgressView = Float(b/a)
        
        
        
        
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func actionDone(_ sender: Any) {
        let welldone = Welldone()
        welldone.fillMassives(completion: {(success) in
            
            welldone.makeItemDone(model: self.cardViewModel ?? EventModel())
            self.dismiss(animated: true, completion: nil)
            self.delegateUpdate?.update(completion: {(success) in
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
}

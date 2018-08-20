//
//  TipViewController.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 19/07/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import Firebase

class TipViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tipDescrpLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var titleText = ""
    
    var tipText = ""
    
    var stepId = ""

    
    
    var ref: DatabaseReference!
    var user: User?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.layer.cornerRadius = 5
        
        titleLabel.text = titleText
        tipDescrpLabel.text = tipText
        
        
        //-------- online ----------
        titleLabel.fadeOut()
        tipDescrpLabel.fadeOut()
        doneButton.fadeOut()
        
        activityIndicator.center = CGPoint.init(x: self.view.frame.size.width / 2, y: 120)//self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        ref = Database.database().reference()
        user = Auth.auth().currentUser
        ref.child("users/\(user!.uid)/project/steps/\(stepId)").observeSingleEvent(of: .value, with: {(snapshot) in
            
            let v = snapshot as? DataSnapshot
            let value = v?.value as! NSDictionary
            
            let model = EventModel()
            
            
            model.title = value["title"] as? String ?? ""
            model.subtitle = value["subtitle"] as? String ?? ""
            
            let endingDateString = value["endingDate"] as? String ?? ""
            let startingDateString = value["startingDate"] as? String ?? ""
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let dateStart = dateFormatter.date(from: startingDateString)
            model.startingDate = dateStart
            let dateEnd = dateFormatter.date(from: endingDateString)
            model.endingDate = dateEnd
            model.startingTime = value["startingTime"] as? String ?? ""
            model.isDone = value["isDone"] as? Int ?? 0
            
            model.endingTime = value["endingTime"] as? String ?? ""
            model.text = value["text"] as? String ?? ""
            
            self.titleLabel.text = model.title
            
            self.activityIndicator.stopAnimating()
            self.titleLabel.fadeIn()
            self.tipDescrpLabel.fadeIn()
            self.doneButton.fadeIn()
        })
        
        
    }
    
    @IBAction func doneAction(_ sender: Any) {
        ref.child("users/\(user!.uid)/project/steps/\(stepId)/isDone").setValue(1)
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  DetailedEventViewController.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 07/07/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import Firebase

protocol CardDetailInteractivityDelegate: class {
    func shouldDragDownToDismiss()
}


class DetailedEventViewController: AnimatableStatusBarViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var ref: DatabaseReference!
    var user: User?
    

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textView: UILabel!
    
    @IBOutlet weak var buttonDone: UIButton!
    weak var delegateUpdate: UpdateAllItems?
    
    @IBOutlet weak var tableView: UITableView!
    
    var minitasksArray = [MinitaskModel]()
    

    @IBOutlet weak var dateStartLabel: UILabel!
    @IBOutlet weak var dateEndLabel: UILabel!
    @IBOutlet weak var progressDate: UIProgressView!
    
    
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
        imageView.asCircle()
        imageView.image = cardViewModel?.image
        
        buttonDone.layer.cornerRadius = 5
        if(cardViewModel?.isDone == 1){
            self.buttonDone.fadeOut()
            
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        getMiniTasks()
        
        if(cardViewModel != nil){
            DispatchQueue.main.async {
                
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        
        let lStart = dateFormatter.string(from: cardViewModel?.startingDate ?? Date())
        let lEnd = dateFormatter.string(from: cardViewModel?.endingDate ?? Date())
        
        dateStartLabel.text = lStart
        dateEndLabel.text = lEnd
        
        
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
        scrollView.delegate = self
        

    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
   
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let shouldScrollEnabled: Bool
        if self.scrollView.isTracking && scrollView.contentOffset.y < -50 {
            shouldScrollEnabled = false
            self.dismiss(animated: true, completion: nil)
        } else {
            shouldScrollEnabled = true
        }
        
        // Update only on change
        if shouldScrollEnabled != scrollView.isScrollEnabled {
            scrollView.showsVerticalScrollIndicator = shouldScrollEnabled
            scrollView.isScrollEnabled = shouldScrollEnabled
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return minitasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "MiniTaskShowTableViewCell") as? MiniTaskShowTableViewCell else {
            return UITableViewCell()
        }
        
        cell.labelMinitaskTitle.text = minitasksArray[indexPath.row].title
        cell.indicImage.asCircle()
        if(minitasksArray[indexPath.row].isDone == 1){
            cell.indicImage.image = #imageLiteral(resourceName: "green_in.png").resize(toWidth: 70)
        }else{
            cell.indicImage.image = #imageLiteral(resourceName: "red_in.png").resize(toWidth: 70)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    
    func getMiniTasks(){
        ref = Database.database().reference()
        user = Auth.auth().currentUser
        ref.child("users/\(self.user!.uid)/project/steps/\(cardViewModel!.stepIndex)/miniTasks/").observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children{
                let childData = child as? DataSnapshot
                let value = childData?.value as! NSDictionary
                var model: MinitaskModel = MinitaskModel()
                model.title = value["title"] as? String ?? ""
                model.isDone = value["isDone"] as? Int ?? 0
                
                self.minitasksArray.append(model)
            }
            self.tableView.reloadData()
    })
        
        
    }
    

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionDone(_ sender: Any) {
       buttonDone.fadeOut()
        let welldone = Welldone()
        welldone.fillMassives(completion: {(success) in
            welldone.makeItemDone(model: self.cardViewModel ?? EventModel())
            self.delegateUpdate?.update(completion: {(success) in
                print("test")
               
              
                self.dismiss(animated: true, completion: nil)
                
            
                
                
            })
        
    })
    }

}

class MiniTaskShowTableViewCell: UITableViewCell{
    @IBOutlet weak var indicImage: UIImageView!
    @IBOutlet weak var labelMinitaskTitle: UILabel!
    
}

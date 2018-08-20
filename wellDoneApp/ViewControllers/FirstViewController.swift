//
//  FirstViewController.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 03/07/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import Firebase

let kHighlightedFactor: CGFloat = 0.96



class FirstViewController: AnimatableStatusBarViewController, UITableViewDataSource, UITableViewDelegate, UpdateAllItems
{
    func update(completion: @escaping (Bool) -> Void) {
        //        reload()
        completion(true)
    }
    
    @IBOutlet weak var noWork: UILabel!
    
    @IBOutlet weak var noUndone: UILabel!
    
    @IBOutlet weak var constraintInWork: NSLayoutConstraint!
    
    @IBOutlet weak var constraintDone: NSLayoutConstraint!
    @IBOutlet weak var constraintUndone: NSLayoutConstraint!
    @IBOutlet weak var noDone: UILabel!
    
    @IBOutlet weak var inWork: UILabel!
    @IBOutlet weak var undone: UILabel!
    @IBOutlet weak var done: UILabel!
    
    var modelsDone = [EventModel]()
    var modelsUndone = [EventModel]()
    var modelsToWork = [EventModel]()
    
    let loc = Locale.init(identifier: "ru")

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewUndone: UITableView!
    @IBOutlet weak var tableViewDone: UITableView!
    
    
    
    override var animatedStatusBarPrefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    
    
    var models = [EventModel]()
    
    lazy var wellDone = Welldone()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        reload()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableViewDone.dataSource = self
        tableViewDone.delegate = self
        tableViewUndone.dataSource = self
        tableViewUndone.delegate = self
        
        let user = Auth.auth().currentUser
        
        if(user?.uid != nil){
            wellDone = Welldone()
        }
        
        activityIndicator.center = CGPoint.init(x: self.view.frame.size.width / 2, y: 120)//self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
        
        //        activityIndicator.startAnimating()
        
        
        
        
        //        wellDone.fillMassives(completion:{ (success) in
        //            if(success){
        //                self.models = self.wellDone.items as! [EventModel]
        //                self.tableView.reloadData()
        //                self.activityIndicator.stopAnimating()
        //            }
        //        })
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if(tableView == self.tableView){
            count = modelsToWork.count
        }else if(tableView == self.tableViewDone){
            count = modelsDone.count
        }else if(tableView == self.tableViewUndone){
            count = modelsUndone.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(tableView){
        case self.tableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventModelTableViewCell") as? EventModelTableViewCell else{
                return UITableViewCell()
            }
            
            
            let model = modelsToWork[indexPath.row]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM"
            

            
            dateFormatter.locale = loc
            
            cell.dateLabel.text = dateFormatter.string(from: model.endingDate)
            
            cell.titleLabel.text = model.title
            cell.imageViewIndic.asCircle()
            cell.imageViewIndic.image = model.image
            return cell
        case self.tableViewUndone:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventUndoneTableViewCell") as? EventUndoneTableViewCell else{
                return UITableViewCell()
            }
            
            let model = modelsUndone[indexPath.row]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM"
            dateFormatter.locale = loc

            cell.dateLabel.text = dateFormatter.string(from: model.endingDate)
            
            cell.titleLabel.text = model.title
            cell.imageViewIndic.asCircle()
            cell.imageViewIndic.image = model.image
            return cell
        case self.tableViewDone:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventDoneTableViewCell") as? EventDoneTableViewCell else{
                return UITableViewCell()
            }
            
            let model = modelsDone[indexPath.row]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM"
            dateFormatter.locale = loc

            cell.dateLabel.text = dateFormatter.string(from: model.endingDate)
            
            cell.titleLabel.text = model.title
            cell.imageViewIndic.asCircle()
            cell.imageViewIndic.image = model.image
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(tableView == self.tableView){
            let TrashAction = UIContextualAction(style: .normal, title:  "Удалить", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                self.wellDone.delete(model: self.modelsToWork[indexPath.row], completion: {(success) in
                    self.reload()
                })
                
                print("Update action ...")
                success(true)
            })
            TrashAction.backgroundColor =  UIColor.init(rgbColorCodeRed: 240, green: 69, blue: 0, alpha: 100)
            
            // Write action code for the Flag
            
            
            return UISwipeActionsConfiguration(actions: [TrashAction])
        }else if(tableView == self.tableViewDone){
            let TrashAction = UIContextualAction(style: .normal, title:  "Удалить", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                self.wellDone.delete(model: self.modelsDone[indexPath.row], completion: {(success) in
                    self.reload()
                })
                
                print("Update action ...")
                success(true)
            })
            TrashAction.backgroundColor =  UIColor.init(rgbColorCodeRed: 240, green: 69, blue: 0, alpha: 100)
            
            // Write action code for the Flag
            
            
            return UISwipeActionsConfiguration(actions: [TrashAction])
        }else{
            let TrashAction = UIContextualAction(style: .normal, title:  "Удалить", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                self.wellDone.delete(model: self.modelsUndone[indexPath.row], completion: {(success) in
                    self.reload()
                })
                
                print("Update action ...")
                success(true)
            })
            TrashAction.backgroundColor =  UIColor.init(rgbColorCodeRed: 240, green: 69, blue: 0, alpha: 100)
            
            // Write action code for the Flag
            
            
            return UISwipeActionsConfiguration(actions: [TrashAction])
        }
        
        return UISwipeActionsConfiguration(actions: [])
        
       
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if(tableView == self.tableView){
        let modelRightOnSwipe = modelsToWork[indexPath.row]
        if(modelRightOnSwipe.isDone == 0){
            let DoneAction = UIContextualAction(style: .normal, title:  "Готово!", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                self.wellDone.makeItemDone(model: self.modelsToWork[indexPath.row])
                self.reload()
                print("Update action ...")
                success(true)
            })
            DoneAction.backgroundColor  = UIColor.init(rgbColorCodeRed: 80, green: 200, blue: 100, alpha: 100)
            
            let ToWorkAction = UIContextualAction(style: .normal, title:  "Работаю", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                self.wellDone.makeItemWork(model: self.modelsDone[indexPath.row])
                self.reload()
                print("Update action ...")
                success(true)
            })
            
            ToWorkAction.backgroundColor = UIColor.init(rgbColorCodeRed: 48, green: 79, blue: 254, alpha: 100)
            
            return UISwipeActionsConfiguration(actions: [DoneAction, ToWorkAction])
            
        }else{
            let DoneAction = UIContextualAction(style: .normal, title:  "Готово!", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                self.wellDone.makeItemDone(model: self.modelsToWork[indexPath.row])
                self.reload()
                print("Update action ...")
                success(true)
            })
            DoneAction.backgroundColor  = UIColor.init(rgbColorCodeRed: 80, green: 200, blue: 100, alpha: 100)
            
            
            
            return UISwipeActionsConfiguration(actions: [DoneAction])
        }
        }else if(tableView == self.tableViewDone){
            let modelRightOnSwipe = modelsDone[indexPath.row]
            if(modelRightOnSwipe.isDone == 0){
                let DoneAction = UIContextualAction(style: .normal, title:  "Готово!", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    self.wellDone.makeItemDone(model: self.modelsDone[indexPath.row])
                    self.reload()
                    print("Update action ...")
                    success(true)
                })
                DoneAction.backgroundColor  = UIColor.init(rgbColorCodeRed: 80, green: 200, blue: 100, alpha: 100)
                
                
                let ToWorkAction = UIContextualAction(style: .normal, title:  "Работаю", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    self.wellDone.makeItemWork(model: self.modelsDone[indexPath.row])
                    self.reload()
                    print("Update action ...")
                    success(true)
                })
                
                ToWorkAction.backgroundColor = UIColor.init(rgbColorCodeRed: 48, green: 79, blue: 254, alpha: 100)
                
                return UISwipeActionsConfiguration(actions: [DoneAction, ToWorkAction])
            }else{
                let DoneAction = UIContextualAction(style: .normal, title:  "Отмена", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    self.wellDone.makeItemUndone(model: self.modelsDone[indexPath.row])
                    self.reload()
                    print("Update action ...")
                    success(true)
                })
                
                
                
             
                
                DoneAction.backgroundColor  =  UIColor.init(rgbColorCodeRed: 200, green: 150, blue: 0, alpha: 100)
               
                
                return UISwipeActionsConfiguration(actions: [DoneAction])
            }
        }else{
            let modelRightOnSwipe = modelsUndone[indexPath.row]
            if(modelRightOnSwipe.isDone == 0){
                let DoneAction = UIContextualAction(style: .normal, title:  "Готово!", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    self.wellDone.makeItemDone(model: self.modelsUndone[indexPath.row])
                    self.reload()
                    print("Update action ...")
                    success(true)
                })
                DoneAction.backgroundColor  = UIColor.init(rgbColorCodeRed: 80, green: 200, blue: 100, alpha: 100)
                
                let ToWorkAction = UIContextualAction(style: .normal, title:  "Работаю", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    self.wellDone.makeItemWork(model: self.modelsUndone[indexPath.row])
                    self.reload()
                    print("Update action ...")
                    success(true)
                })
                
                ToWorkAction.backgroundColor = UIColor.init(rgbColorCodeRed: 48, green: 79, blue: 254, alpha: 100)
                
                return UISwipeActionsConfiguration(actions: [DoneAction, ToWorkAction])
            }else{
                let DoneAction = UIContextualAction(style: .normal, title:  "Отмена", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    self.wellDone.makeItemUndone(model: self.modelsUndone[indexPath.row])
                    self.reload()
                    print("Update action ...")
                    success(true)
                })
                DoneAction.backgroundColor  =  UIColor.init(rgbColorCodeRed: 200, green: 150, blue: 0, alpha: 100)
                
                let ToWorkAction = UIContextualAction(style: .normal, title:  "Работаю", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    self.wellDone.makeItemWork(model: self.modelsDone[indexPath.row])
                    self.reload()
                    print("Update action ...")
                    success(true)
                })
                
                ToWorkAction.backgroundColor = UIColor.init(rgbColorCodeRed: 48, green: 79, blue: 254, alpha: 100)
                
                
                return UISwipeActionsConfiguration(actions: [DoneAction, ToWorkAction])
            }
        }
        
        return UISwipeActionsConfiguration(actions: [])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        
        
        
        guard let vc = segue.destination as? NewEventViewController else{
            guard let cell = sender as? EventModelTableViewCell,
                let vc = segue.destination as? DetailedEventViewController else {
                    
                    guard let cell = sender as? EventDoneTableViewCell, let vc = segue.destination as? DetailedEventViewController else{
                        
                        guard let cell = sender as? EventUndoneTableViewCell, let vc = segue.destination as? DetailedEventViewController else{
                            return
                        }
                        vc.delegateUpdate = self
                        let indexPath = tableViewUndone.indexPath(for: cell)
                        vc.cardViewModel = modelsUndone[indexPath?.row ?? 0]
                        
                        return
                    }
                    vc.delegateUpdate = self
                    let indexPath = tableViewDone.indexPath(for: cell)
                    vc.cardViewModel = modelsDone[indexPath?.row ?? 0]
                    
                    return
            }
            
            
            vc.delegateUpdate = self
            let indexPath = tableView.indexPath(for: cell)
            vc.cardViewModel = modelsToWork[indexPath?.row ?? 0]
            return
        }
        
        vc.delegateUpdate = self
    }
    
    func reload(){
        
        
        tableView.fadeOut()
        tableViewDone.fadeOut()
        tableViewUndone.fadeOut()
        inWork.fadeOut()
        undone.fadeOut()
        done.fadeOut()
        
        noDone.fadeOut()
        noWork.fadeOut()
        noUndone.fadeOut()
        
        
        
        
        activityIndicator.startAnimating()
        wellDone.items.removeAll()
        
        //        tableView.delete(nil)
        
        
        models = [EventModel]()
        modelsToWork = [EventModel]()
        modelsUndone = [EventModel]()
        modelsDone = [EventModel]()
        
        wellDone.fillMassives(completion: {(success) in
            if(success){
                self.models = self.wellDone.items as! [EventModel]
                
                
                //-----Yeeeeeee Backend---------
                for i in self.models{
                    if(i.isDone == 0){
                        self.modelsUndone.append(i)
                    }else if(i.isDone == 1){
                        self.modelsDone.append(i)
                    }else{
                        self.modelsToWork.append(i)
                    }
                }
                
                
                
                self.tableView.reloadData()
                self.tableViewUndone.reloadData()
                self.tableViewDone.reloadData()
                
                self.activityIndicator.stopAnimating()
                
                
                if(self.modelsToWork.count <= 1){
                    self.constraintInWork.constant = 100
                }else{
                    self.constraintInWork.constant = 200
                }
                
                if(self.modelsDone.count <= 1){
                    self.constraintDone.constant = 100
                }else{
                    self.constraintDone.constant = 200
                }
                
                if(self.modelsUndone.count <= 1){
                    self.constraintUndone.constant = 100
                }else{
                    self.constraintUndone.constant = 200
                }
                
                if(self.modelsToWork.count != 0){
                    self.tableView.fadeIn()
                }else{
                    self.noWork.fadeIn()
                }
                if(self.modelsDone.count != 0){
                    self.tableViewDone.fadeIn()
                }else{
                    self.noDone.fadeIn()
                }
                if(self.modelsUndone.count != 0){
                self.tableViewUndone.fadeIn()
                }else{
                    self.noUndone.fadeIn()
                }
                
                
                self.inWork.fadeIn()
                self.done.fadeIn()
                self.undone.fadeIn()
                
                
                
            }
        })
        
    }
    
    
    
    
}

class EventUndoneTableViewCell: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageViewIndic: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
}

class EventDoneTableViewCell: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageViewIndic: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
}


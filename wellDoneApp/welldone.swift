//
//  welldone.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 22/07/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import Foundation
import Firebase

public class Welldone {
    var user:User?
    var items = [EventModel?]()
    let sModel = SmartModel()
    var refMl:DatabaseReference?
    let completionMode = 0;
    
    
    var arrayForTableView = Dictionary<String, Array<EventModel>>()
    var sortedSections = [String]()
    
    var ref: DatabaseReference!
    
    func delete(model: EventModel, completion: @escaping (Bool) -> Void){
        self.ref.child("users/\(self.user!.uid)/project/steps/\(model.stepIndex)").removeValue()
        self.ref.child("mlTasks/\(self.user!.uid)/\(model.stepIndex)").removeValue()
        self.ref.child("mlTasks/\(self.user!.uid)/\(model.stepIndex)/r").setValue(0)
        completion(true)
    }
    
    
    func ml(completion:@escaping (SmartModel) -> Void){
        for model in self.items{
            if(model?.isDone != 1){
                
                let calendar = NSCalendar.current
                
                let dateStart = calendar.startOfDay(for: (model?.startingDate)!)
                let dateEnd = calendar.startOfDay(for: (model?.endingDate)!)
                let dateNow = calendar.startOfDay(for: NSDate() as Date)
                
                let components = calendar.dateComponents([.day], from: dateStart, to: dateEnd)
                let components2 = calendar.dateComponents([.day], from: dateStart, to: dateNow)
                let components3 = calendar.dateComponents([.day], from: dateNow, to: dateEnd)
                
                let a = Float(components2.day!)
                let b = Float(components.day!)
                
                let f = Float(a/b)
                let g = components3.day!
                
                let pathFB: String = "mlTasks/\(self.user!.uid)/\(model!.stepIndex)"
                
                print(pathFB)
                
                self.ref.child(pathFB).setValue(["p1":model!.importance,
                                                 "p2":f,
                                                 "p3":g,
                                                 "r":0
                    ])
                
                refMl = self.ref.child(byAppendingPath: "mlTasks/\(self.user!.uid)/\(model!.stepIndex)")
                refMl!.observe(DataEventType.childChanged, with: {(snapshot) in
                    let result = snapshot.value as? Int ?? 0
                    if(result != 0){
                        self.sModel.eventModel = model
                        switch(result){
                        case 1:
                            self.sModel.title = "wellDone рекомендует вам скорее завершить это :)"
                            self.sModel.description = "Завершите часть \(model!.title) прямо сейчас! :)"
                        case 2:
                            self.sModel.title = "wellDone рекомендует вам упорнее работать!"
                            self.sModel.description = "Упорнее работайте над частью \(model!.title) :)"
                        case 3:
                            self.sModel.title = "wellDone рекомендует вам пересмотреть ваш таймлайн!"
                            self.sModel.description = "Пересмотрите план выполнения проекта \(model!.title) :)"
                        default:
                            self.sModel.title = "Что то пошло не так :("
                            self.sModel.description = ""
                            
                        }
                    }
                    
                    completion(self.sModel)

                })
                

                
            }
            
            
        }
        
    }
    
    func makeItemWork(model: EventModel){
        ref.child("users/\(user!.uid)/project/steps/\(model.stepIndex)/isDone").setValue(2)
    }
    
    func makeItemUndone(model: EventModel){
         ref.child("users/\(user!.uid)/project/steps/\(model.stepIndex)/isDone").setValue(0)
    }
    
    func getUndoneItems() -> [EventModel]{
        
        var mas = [EventModel]()
        for i in items{
            if(i?.isDone == 0){
                mas.append(i ?? EventModel())
            }
        }
        
        
        return mas
    }
    
  
    func makeItemDone(model: EventModel){

        ref.child("users/\(user!.uid)/project/steps/\(model.stepIndex)/isDone").setValue(1)
    }
    
    func filling(child: Any){
        var model: EventModel = EventModel()
        let childData = child as? DataSnapshot
        let value = childData?.value as! NSDictionary
        model.title = value["title"] as? String ?? ""
        model.subtitle = value["subtitle"] as? String ?? ""
        
        let endingDateString = value["endingDate"] as? String ?? ""
        let startingDateString = value["startingDate"] as? String ?? ""
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let dateStart = dateFormatter.date(from: startingDateString)
        model.startingDate = dateStart!
        let dateEnd = dateFormatter.date(from: endingDateString)
        model.endingDate = dateEnd!
        model.startingTime = value["startingTime"] as? String ?? ""
        model.endingTime = value["endingTime"] as? String ?? ""
        model.text = value["text"] as? String ?? ""
        model.isDone = value["isDone"] as? Int ?? 0
        model.importance = value["importance"] as? Int ?? 0
        model.hardRate = value["hard"] as? Int ?? 0
        model.stepIndex = (childData?.key)!
        if(model.isDone == 1){
            model.image = #imageLiteral(resourceName: "green_in.png").resize(toWidth: 70)
        }else if(model.isDone == 0){
            model.image = #imageLiteral(resourceName: "red_in.png").resize(toWidth: 70)
        }else{
            model.image = #imageLiteral(resourceName: "yellow_in.png").resize(toWidth: 70)
        }
        self.items.append(model)
        
        if(self.arrayForTableView.index(forKey: startingDateString) == nil){
            self.arrayForTableView[startingDateString] = [model]
            self.sortedSections.append(startingDateString)
        }else{
            self.arrayForTableView[startingDateString]!.append(model)
        }
        
        
        for i in 0..<self.sortedSections.count{
            var pos = i
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            var tmp = dateFormatter.date(from: self.sortedSections[i])
            for j in i+1..<self.sortedSections.count{
                let now = dateFormatter.date(from: self.sortedSections[j])
                if(now! < tmp!){
                    pos = j
                    tmp = now
                }
            }
            
            self.sortedSections[pos] = self.sortedSections[i]
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "dd/MM/yyyy"
            self.sortedSections[i] = dateFormatter2.string(from: tmp!)
            
        }
    }
    
    func fillMassives(completion: @escaping (Bool) -> Void){
        ref = Database.database().reference()
        
        user = Auth.auth().currentUser
        
        print("users/\(user!.uid)/project/steps")
        
        items.removeAll()
        
        
        ref.child("users/\(user!.uid)/project/steps").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children{
                self.filling(child: child)
            }
            completion(true)
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}

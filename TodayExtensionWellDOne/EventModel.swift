//
//  EventModel.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 03/07/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

struct EventModel{
    var startingTime:String
    var endingTime:String
    var startingDate:Date
    var endingDate:Date
    var title:String
    var subtitle:String
    var text: String
    var importance: Int
    var isDone:Int
    var stepIndex: String    
    
    
    init() {
        self.title = ""
        self.subtitle = ""
        self.text = ""
        self.importance = 0
        self.isDone = 0
        self.stepIndex = ""
        self.startingTime = ""
        self.startingDate = Date()
        self.endingTime = ""
        self.endingDate = Date()
        
    }
    
    
    
}

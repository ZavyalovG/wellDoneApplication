//
//  EventModel.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 03/07/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

public struct EventModel{
    var startingTime:String
    var endingTime:String
    var startingDate:Date
    var endingDate:Date
    var title:String
    var subtitle:String
    var text: String
    var hardRate: Int
    var importance: Int
    var isDone:Int
    var stepIndex: String
    var image: UIImage
    
    
   
    init() {
        self.title = ""
        self.subtitle = ""
        self.text = ""
        self.importance = 0
        self.hardRate = 0
        self.isDone = 0
        self.stepIndex = ""
        self.startingTime = ""
        self.startingDate = Date()
        self.endingTime = ""
        self.endingDate = Date()
        self.image = UIImage()
        
    }
    
    func scaledHighlightImageState() -> EventModel {
        let scaledImage = image.resize(toWidth: image.size.width * 0.96)
        
        var evM = EventModel()
        evM.title = title
        evM.subtitle = subtitle
        evM.startingTime = startingTime
        evM.endingTime = endingTime
        evM.startingDate = startingDate
        evM.endingDate = endingDate
        evM.text = text
        evM.hardRate = hardRate
        evM.importance = importance
        evM.isDone = isDone
        evM.stepIndex = stepIndex
        evM.image = scaledImage
        
        return evM
    }
    
}

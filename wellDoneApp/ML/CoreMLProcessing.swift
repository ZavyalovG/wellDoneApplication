//
//  CoreMLProcessing.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 19/08/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import Foundation
import CoreML

class KarmaCoreMLProcessing {
    let model = KarmaCoreMLModel()
    func predict(param1: Double, param2:Double, param3:Double) -> Int64 {
   
        guard let preds =  try? model.prediction(param1: param1, param2: param2, param3: param3) else{
            return 0
        }
        return preds.karma
    }
}

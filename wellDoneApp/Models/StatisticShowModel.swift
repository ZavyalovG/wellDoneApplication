//
//  File.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 14/08/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import Foundation

enum StatClassEnum{
    case percantageStat
    case numirateStat
}

class StatisticShowModel{
    var statName:String?
    var statClass: StatClassEnum?
    var discription: String?
}

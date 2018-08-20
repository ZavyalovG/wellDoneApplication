//
//  ModelStatistics.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 20/08/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import Foundation

enum StatisticsRate{
    case wow
    case great
    case okey
    case soso
    case bad
}

class StatisticsModel{
    var statisticsRate:StatisticsRate?
}

//
//  TodayViewController.swift
//  TodayExtensionWellDOne
//
//  Created by Глеб Завьялов on 17/08/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
  
    
//
//    @IBOutlet weak var tableView: UITableView!
//
//    lazy var wellDone = Welldone()
//    var models = [EventModel?]()

    override func viewDidLoad() {
        super.viewDidLoad()
//
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.reloadData()
        
//        wellDone.fillMassives(completion: {(success) in
//            if(success){
//                self.models = self.wellDone.items
//            }else{
//                print("ERRROOOOOOOOR")
//            }
//        })
    }
    
//    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
//        if activeDisplayMode == .compact {
//            self.preferredContentSize = maxSize
//        } else if activeDisplayMode == .expanded {
//            self.preferredContentSize = CGSize(width: maxSize.width, height: 150)
//        }
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "widgetCard") as? TodayExtensionTableViewCell else{
//            return UITableViewCell()
//        }
//        cell.titleLAbel.text = "Teeest"
//        return cell
//    }
//
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        completionHandler(NCUpdateResult.newData)
    }

}


class TodayExtensionTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLAbel: UILabel!
    
    
    
}

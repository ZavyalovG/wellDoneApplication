//
//  TeacherChildrenViewController.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 20/08/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit


class TeacherChildrenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var arrayChildren = [ChildrenModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayChildren.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChildrenTableViewCell") as? ChildrenTableViewCell else {
            return UITableViewCell()
        }
        
        cell.nameChildren.text = arrayChildren[indexPath.row].name
        
        
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}




class ChildrenTableViewCell: UITableViewCell{
    @IBOutlet weak var nameChildren: UILabel!
}

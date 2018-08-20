//
//  NewEventViewController.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 05/07/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import Firebase

protocol UpdateAllItems: class {
    func update(completion: @escaping (Bool) -> Void)
}


class NewEventViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
   
    
    
    var minitaskArray = [MinitaskModel]()
    
    @IBOutlet weak var buttonAddMiniTask: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    
    var countOfSteps:Int = 0
    
    var datePickerIndexPath: IndexPath?
    var inputTexts: [String] = ["Start: ", "End: "]
    var inputDates: [Date] = []
    

    var allDateFormatter = DateFormatter()
    

    var placeHolderText = "Опишите эту часть"

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var importanceLabel: UILabel!
    
    @IBOutlet weak var hardenceSlider: UISlider!
    @IBOutlet weak var hardenceLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    var user: User?
    
    var viewController:FirstViewController?
    
    weak var delegateUpdate: UpdateAllItems?


    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        buttonAddMiniTask.layer.cornerRadius = 7
    
        
        startDatePicker.setValue(UIColor.white, forKey: "textColor")
        endDatePicker.setValue(UIColor.white, forKey: "textColor")
        let loc = Locale.init(identifier: "ru")
        startDatePicker.locale = loc
        endDatePicker.locale = loc

        hardenceSlider.minimumValue = 1
        hardenceSlider.maximumValue = 10
        
        slider.maximumValue = 10
        slider.minimumValue = 1
        
        descriptionTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        addInitailValues()

    
        
        ref = Database.database().reference()
        user = Auth.auth().currentUser
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return minitaskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MiniTaskTableViewCell") as? MiniTaskTableViewCell else{
            return UITableViewCell()
        }
        cell.label.text = minitaskArray[indexPath.row].title
        
        return cell
    }
    
    func addInitailValues() {
        inputDates = Array(repeating: Date(), count: inputTexts.count)
    }
    
    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        self.descriptionTextField.textColor = .black
        
        if(self.descriptionTextField.text == placeHolderText) {
            self.descriptionTextField.text = ""
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func clickAddMiniTask(_ sender: Any) {
        let alert = UIAlertController(title: "Мини таск", message: "Чем ты планируешь заниматься?", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
      
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            //some action
            var model = MinitaskModel()
            model.isDone = 0
            model.title = textField?.text ?? ""
            self.minitaskArray.append(model)
            self.tableView.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(descriptionTextField.text == "") {
            self.descriptionTextField.text = placeHolderText
            self.descriptionTextField.textColor = .lightGray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
            self.descriptionTextField.text = placeHolderText
            self.descriptionTextField.textColor = .lightGray
        
    }
    
    
    
    
    
    
    @IBAction func importanceChangedAction(_ sender: Any) {
        importanceLabel.text = "Важность части: \(Int(slider.value))"
    }

    @IBAction func hardenceChangedAction(_ sender: Any) {
        hardenceLabel.text = "Сложность выполнения: \(Int(hardenceSlider.value))"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    @IBAction func createAction(_ sender: Any) {
        let title = titleTextField.text
        let subtitle = "..."
        let description = descriptionTextField.text
        var dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd/MM/yyyy"
        let startingDate = dateFormatter1.string(from: startDatePicker.date)
        var dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "HH.mm"
        let startingTime = dateFormatter2.string(from: startDatePicker.date)
        let endingDate = dateFormatter1.string(from: endDatePicker.date)
        let endingTime = dateFormatter2.string(from: endDatePicker.date)
        
        ref.child("users/\(self.user!.uid)/project").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            self.countOfSteps = value?["countOfSteps"] as? Int ?? 0
            
            self.countOfSteps = self.countOfSteps + 1
            
            self.ref.child("users/\(self.user!.uid)/project").updateChildValues(["countOfSteps":self.countOfSteps])
            self.ref.child("users/\(self.user!.uid)/project/steps/\(self.countOfSteps)/").setValue(["endingDate":endingDate,
                                                                                "endingTime":endingTime,
                                                                                "startingDate":startingDate,
                                                                                "startingTime":startingTime,
                                                                                "subtitle":subtitle,
                                                                                "isDone":0,
                                                                                "importance":Int(self.slider.value),
                                                                                "hard":Int(self.hardenceSlider.value),
                                                                                "title":title,
                                                                                "miniTaskSize":self.minitaskArray.count,
                                                                                "text":description])
            
            
            for i in 0..<self.minitaskArray.count{
                self.ref.child("users/\(self.user!.uid)/project/steps/\(self.countOfSteps)/miniTasks/\(i)").setValue(["title":self.minitaskArray[i].title,
                                                                                                                      "isDone":self.minitaskArray[i].isDone])
            }
            
            self.dismiss(animated: true, completion: {})
            self.delegateUpdate?.update(completion: { (success) in
                if(success){
                    self.dismiss(animated: true, completion: {})
                }
            })

            
        })
        
        
        
        
    }
    @IBAction func backAction(_ sender: Any) {
        self.delegateUpdate?.update(completion: { (success) in
            if(success){
                self.dismiss(animated: true, completion: {})
            }
        })

    }
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
    {
        // make it look (initially) like a placeholder
        aTextview.textColor = UIColor.lightGray
        aTextview.text = placeholderText
    }
    
}

class MiniTaskTableViewCell: UITableViewCell{
    @IBOutlet weak var label: UILabel!
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}


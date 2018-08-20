//
//  DetailedKarmaViewController.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 14/08/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
//import Charts
class DetailedKarmaViewController: AnimatableStatusBarViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UpdateAllItems {
    
    
    @IBOutlet weak var completionLabelTableView: UILabel!
    
    var models = [EventModel?]()
    lazy var wellDone = Welldone()
    
    @IBOutlet weak var cardContentView: MainCardContent!
    
    @IBOutlet weak var meanHardRate: UILabel!
    @IBOutlet weak var percentOfDone: UILabel!
    @IBOutlet weak var wellDoneRate: UILabel!
    @IBOutlet weak var countOfAllTasks: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var viewStats: UIView!
    
    weak var interDel:UpdateAllItems?
    
    var karmaModel:ProjectKarmaModel?{
        didSet{
            if self.cardContentView != nil {
                cardContentView.karmaModel = karmaModel
            }
        }
    }
    
    weak var interactivityDelegate: CardDetailInteractivityDelegate?
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        completionLabelTableView.isHidden = true
        
        viewStats.layer.cornerRadius = 10
        
        tableView.delegate = self
        tableView.dataSource = self
        
        activityIndicator.center = CGPoint.init(x: self.view.frame.size.width / 2, y: 220)//self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
        tableView.fadeOut()
        viewStats.fadeOut()
        
        activityIndicator.startAnimating()
        
        wellDone.fillMassives(completion: {(success) in
            if(success){
                
                self.models = self.wellDone.getUndoneItems()
                if(self.models.count != 0){
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.tableView.fadeIn()
                }else{
                    self.completionLabelTableView.fadeIn()
                        self.completionLabelTableView.isHidden = false
                }
                self.activityIndicator.stopAnimating()
                self.loadStatistic()
                self.viewStats.fadeIn()

            }
        })
        scrollView.delegate = self
        cardContentView.karmaModel = karmaModel
        cardContentView.fontState(isHighlighted: true)
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func loadStatistic(){
        var meanStatProj = 0
        
        var statisticAllItems = wellDone.items
        var sumHard:Double = 0
        for i in statisticAllItems{
            sumHard+=Double(i?.hardRate ?? 0)
        }
        meanStatProj = Int((sumHard/Double(statisticAllItems.count)))
        var countOfDone:Double = 0
        for i in statisticAllItems{
            if(i?.isDone == 1){
                countOfDone+=1
            }
        }
        
        let percentOfDoneTasks = Int(countOfDone/Double(statisticAllItems.count)*100)
        
        
        let countOfTasks = statisticAllItems.count
        
        var sumImportanceNaHard:Double = 0
        for i in statisticAllItems{
            let now:Double = Double(i?.hardRate ?? 0) * Double(i?.importance ?? 0)
            sumImportanceNaHard += now
        }
        
        let wellDoneRateNum:Int = Int(sumImportanceNaHard/Double(statisticAllItems.count))
        
        
        meanHardRate.text = String(meanStatProj)
        countOfAllTasks.text = String(countOfTasks)
        percentOfDone.text = String(percentOfDoneTasks) + "%"
        wellDoneRate.text = String(Int(wellDoneRateNum))
        
    }
    
    func update(completion: @escaping (Bool) -> Void) {
        completionLabelTableView.fadeOut()
        tableView.fadeOut()
        viewStats.fadeOut()
        activityIndicator.startAnimating()
        
        wellDone.fillMassives(completion: {(success) in
            if(success){
                self.models = self.wellDone.getUndoneItems()
                if(self.models.count != 0){
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.tableView.fadeIn()
                    completion(true)
                }else{
                    self.completionLabelTableView.fadeIn()
                        self.completionLabelTableView.isHidden = false
                    
                    
                }
                self.activityIndicator.stopAnimating()
                self.loadStatistic()
                self.viewStats.fadeIn()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cardUndone") as? UndoneTableViewCell else {
            return UITableViewCell()
        }
        
        let dateFormatterCell = DateFormatter()
        dateFormatterCell.dateFormat = "dd MMMM"
        
        cell.dateLabel.text = dateFormatterCell.string(from: models[indexPath.row]?.endingDate ?? Date())
        cell.titleLabel.text = models[indexPath.row]?.title
        cell.indicatorImage.asCircle()
        cell.indicatorImage.image = models[indexPath.row]?.image
        
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let shouldScrollEnabled: Bool
        if self.scrollView.isTracking && scrollView.contentOffset.y < 0 {
            shouldScrollEnabled = false
            self.interactivityDelegate?.shouldDragDownToDismiss()
            interDel?.update(completion: {(success) in
                if(success){
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } else {
            shouldScrollEnabled = true
        }
        
        // Update only on change
        if shouldScrollEnabled != scrollView.isScrollEnabled {
            scrollView.showsVerticalScrollIndicator = shouldScrollEnabled
            scrollView.isScrollEnabled = shouldScrollEnabled
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override var animatedStatusBarPrefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? NewEventViewController else{
            guard let cell = sender as? UndoneTableViewCell,
                let vc = segue.destination as? UndoneDetailedViewController else {
                    guard let vc = segue.destination as? SecondViewController else {
                        return
                    }
                    self.interDel?.update(completion: { (success) in
                        print("vcSecond")
                        })
                    
                    return
            }
            vc.delegateUpdate = self
            let indexPath = tableView.indexPath(for: cell)
            
            vc.cardViewModel = models[indexPath?.row ?? 0]
            return
        }
        
        vc.delegateUpdate = self
    }
    
    
}

class UndoneTableViewCell: UITableViewCell{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var indicatorImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

//
//  TipViewController.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 19/07/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import Firebase

class SecondViewController: AnimatableStatusBarViewController, UpdateAllItems {
    
    
    
    enum Constant {
        static let horizontalInset: CGFloat = 20
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var wellDone = Welldone()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    let mlProcessing = KarmaCoreMLProcessing()
    
    var models = [ProjectKarmaModel]()
    
    var modelStatistics = StatisticsModel()
    
    
    
    private var transitionManager: CardToDetailTransitionManager2!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //        # парам1 = заверш/все проекты
        //        # парам2 = заверш/незаверш
        //        # парам3 = всепроект/незаверш
        
        collectionView.fadeOut()
        
        activityIndicator.center = CGPoint.init(x: self.view.frame.size.width / 2, y: 170)//self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 20
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .init(top: 20, left: 0, bottom: 64, right: 0)
        }
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "\(MainCardStatistics.self)", bundle: nil), forCellWithReuseIdentifier: "card2")
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        update(completion: {(success) in
            return
        })
    }
    
    
    
    
    func update(completion: @escaping (Bool) -> Void) {
        activityIndicator.startAnimating()
        models = [ProjectKarmaModel]()
        collectionView.fadeOut()
        wellDone.fillMassives(completion: {(success) in
            if(success){
                var countOfAllModels:Double = 0
                var countOfDoneModels:Double = 0
                var countOfUndoneModels:Double = 0
                
                countOfAllModels = Double(self.wellDone.items.count)
                
                countOfUndoneModels = Double(self.wellDone.getUndoneItems().count)
                countOfDoneModels = countOfAllModels - countOfUndoneModels
                if(countOfDoneModels != countOfAllModels){
                    let param1:Double = countOfDoneModels/countOfAllModels
                    let param2:Double = countOfDoneModels/countOfUndoneModels
                    let param3:Double = countOfAllModels/countOfUndoneModels
                    
                    let karmaMode = self.mlProcessing.predict(param1: param1, param2: param2, param3: param3)
                    
                    let km = ProjectKarmaModel()
                    
                    switch karmaMode {
                    case 1:
                        km.value = .bad
                    case 2:
                        km.value = .well
                    case 3:
                        km.value = .okey
                    case 4:
                        km.value = .perfect
                    default:
                        km.value = .bad
                    }
                    
                    self.models.append(km)
                    self.collectionView.reloadData()
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.fadeIn()
                    self.activityIndicator.stopAnimating()
                    completion(true)
                    
                }else{
                    let km = ProjectKarmaModel()
                    km.value = .perfect
                    self.models.append(km)
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                    
                    self.collectionView.fadeIn()
                    self.activityIndicator.stopAnimating()
                    completion(true)
                    
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailedKarmaViewController else {
            return
        }
        
        vc.interDel = self
        
    }
    
    override var animatedStatusBarPrefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
}


extension SecondViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card2", for: indexPath) as? MainCardStatistics else{
            return UICollectionViewCell()
        }
        return cell
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! MainCardStatistics
        cell.cardContentView?.karmaModel = models[indexPath.row]
    }
}

extension SecondViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width - 2*Constant.horizontalInset
        let height: CGFloat = width * 0.3333333333
        return CGSize(width: width, height: height)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "DetailedKarmaViewController") as! DetailedKarmaViewController
        let ind = indexPath
        let cardModel = models[ind.row]
        let cell = collectionView.cellForItem(at: ind) as! MainCardStatistics
        
        
        // Freeze animation highlighted state (or else it will bounce back)
        cell.disabledAnimation = true
        cell.layer.removeAllAnimations()
        
        let currentCellFrame = cell.layer.presentation()!.frame
        let cardFrame = cell.superview!.convert(currentCellFrame, to: nil)
        
        vc.karmaModel = cardModel
        
        // Card's frame relative to UIWindow
        let frameWithoutTransform = { () -> CGRect in
            let center = cell.center
            let size = cell.bounds.size
            let r = CGRect(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2,
                width: size.width,
                height: size.height
            )
            return cell.superview!.convert(r, to: nil)
        }()
        
        let params = (fromCardFrame: cardFrame, fromCardFrameWithoutTransform: frameWithoutTransform, viewModel: cardModel, fromCell: cell)
        self.transitionManager = CardToDetailTransitionManager2(params)
        self.transitionManager.cardDetailViewController = vc
        vc.transitioningDelegate = transitionManager
        
        self.present(vc, animated: true, completion: {
            cell.isHidden = false
            
            // Unfreeze
            cell.disabledAnimation = false
        })
    }
}



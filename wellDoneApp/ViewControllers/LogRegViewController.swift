//
//  LogRegViewController.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 07/07/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit
import Firebase

class LogRegViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    
    var ref: DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
      
        
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
        let user = Auth.auth().currentUser
        if(user?.uid != nil){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainScreen") as! UITabBarController
            self.present(newViewController, animated: true, completion: nil)
        }
        }
    }
//
//    override func viewWillDisappear(_ animated: Bool) {
////        Auth.auth().removeStateDidChangeListener(handle!)
//    }
    

    @IBAction func loginAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passTextField.text!) { (user, error) in
            guard let error = error else{
                return
            }
        
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainScreen") as! UITabBarController
            self.present(newViewController, animated: true, completion: nil)

            
        }
    }
    
    @IBAction func regAction(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passTextField.text!){
            (authResult, error) in
            guard let error = error else{
                return
            }
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let user = Auth.auth().currentUser
            
            self.ref.child("users/\(user!.uid)/project/countOfSteps").setValue(0)
            
            
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainScreen") as! UITabBarController
            self.present(newViewController, animated: true, completion: nil)
            
            
            
            
            
        }
    }
    
}

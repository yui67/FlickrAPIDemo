//
//  ViewController.swift
//  FlickrAPIDemo
//
//  Created by Mr.z on 2021/4/7.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - IBOlets
    @IBOutlet weak var searchContentTextField: UITextField!
    @IBOutlet weak var searchNumber: UITextField!
    @IBOutlet weak var searchBtnOutlet: UIButton!
    
    //MARK: - Vars
    var page: String?
    var text: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchContentTextField.delegate = self
        searchNumber.delegate = self
        
        let image = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = image
        
        
        
        
        searchBtnOutlet.isUserInteractionEnabled = false
        searchBtnOutlet.alpha = 0.5
        searchBtnOutlet.setTitleColor(UIColor.white, for: .normal)
        searchBtnOutlet.backgroundColor = UIColor.gray
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        
        searchBtnOutlet.frame = CGRect.init(x: self.view.center.x - 150/2, y: self.view.center.y - 150/2, width: 188, height: 50)
        searchBtnOutlet.layer.cornerRadius = searchBtnOutlet.frame.height/2
        
    }
    
    //MARK: - Actions
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !text.isEmpty{
            searchBtnOutlet?.isUserInteractionEnabled = true
            searchBtnOutlet?.alpha = 1.0
            searchBtnOutlet?.backgroundColor = UIColor.blue
            searchBtnOutlet.setTitleColor(UIColor.white, for: .normal)
            
        } else {
            searchBtnOutlet?.isUserInteractionEnabled = false
            searchBtnOutlet?.alpha = 0.5
            searchBtnOutlet?.backgroundColor = UIColor.gray
            
        }
                
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return  true
    }
    
    
    
    
    //MARK: - IBActions
    @IBSegueAction func searchButton(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> UICollectionViewController? {
        
        if searchNumber.text == "" || searchContentTextField.text == "" {
            
            page = "nil"
            text = "1"
            
            
        }else{
            text = searchContentTextField.text
            page = searchNumber.text
            
        }
        
        let controller = CollectionViewController(coder: coder)
        
        
        controller?.text = text
        controller?.page = page
        
        return controller
    }
    
    
    
}



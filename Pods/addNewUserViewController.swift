//
//  addNewUserViewController.swift
//  Doll
//
//  Created by 陳語安 on 2023/9/21.
//

import UIKit
import RealmSwift


class addNewUserViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var uploadPhoto: UIButton!
    @IBOutlet weak var Image: UIImageView!
    
    private let realm = try! Realm()
    
    public var completionHandler: (()-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserName.becomeFirstResponder()
        UserName.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "儲存", style: .done, target: self, action: #selector(upload))
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UserName.resignFirstResponder()
        return true
    }
    @IBAction func Uploadphoto(_ sender: Any) {
       present(uploadFrom(), animated: true, completion: nil)
    }
    func uploadFrom() -> UIAlertController {
       let controller = UIAlertController(
          title: "照片",
          message: "從照片圖庫選圖片",
          preferredStyle: .alert)
       let photoGallery = UIAlertAction(
          title: "照片圖庫", style: .default) { (_) in
          print("從照片圖庫選圖片")
          self.selectPhoto() // 這個function下一步會提到
       }
       controller.addAction(photoGallery)

       return controller
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          let image = info[.originalImage] as? UIImage
          Image.image = image
          dismiss(animated: true, completion: nil)
    }
       // SelectPhoto delegate -> UIImagePickerController
    func selectPhoto() {
          let controller = UIImagePickerController()
          controller.sourceType = .photoLibrary
          controller.delegate = self
          present(controller, animated: true, completion: nil)
    }
    
    
    @objc func upload(_ sender: Any) {
        if let text = UserName.text , !text.isEmpty{
            
            
            realm.beginWrite()
            let newUser = User()
            let newImage = Image.image
            let photoData = newImage?.jpegData(compressionQuality: 0.8)
            
            newUser.username = text
            newUser.profileImage = photoData
             
            realm.add(newUser)
            try! realm.commitWrite()
            completionHandler!()
            let vc = self.navigationController?.viewControllers.filter({$0 is totalUserViewController}).first
            self.navigationController?.popToViewController(vc!, animated: true)

        }
        else{
            print("Add something")
        }
    }
   
    
}



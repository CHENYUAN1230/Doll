//
//  singleUserViewController.swift
//  Doll
//
//  Created by 陳語安 on 2023/9/21.
//

import UIKit
import RealmSwift

var whichGame: String = ""
var Owner_fromSingleUser: String = ""

class singleUserViewController: UIViewController {

    public var SingleUser: User?
    public var deletionHandler: (()-> Void)?
    
    
    @IBOutlet weak var singeluserName: UILabel!
    @IBOutlet weak var singleUserPhoto: UIImageView!
    
    @IBOutlet weak var btnfamily: UIButton!
    @IBOutlet weak var btnnumber: UIButton!
    @IBOutlet weak var btnlife: UIButton!
    
    @IBOutlet weak var gameStart: UIButton!
    private let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singeluserName.text = SingleUser?.username
        Owner_fromSingleUser = singeluserName.text!
        print(Owner_fromSingleUser)
        
        if let profileImageData = SingleUser?.profileImage,
           let image = UIImage(data: profileImageData) {
            // 在这里使用 'image'，它包含了从 'profileImageData' 中提取的图像数据
            singleUserPhoto.image = image
        }
        //btnlife.imageView?.contentMode = .scaleAspectFit
        //btnlife.setImage(UIImage.init(named: "radio_button_off"), for: .normal)
        if let originalImage = UIImage(named: "radio_button_off") {
            let imageSize = CGSize(width: btnfamily.frame.width, height: btnfamily
                .frame.height)
            let resizedImage = originalImage.resized(to: imageSize)
            btnfamily.setImage(resizedImage, for: .normal)
            btnnumber.setImage(resizedImage, for: .normal)
            btnlife.setImage(resizedImage, for: .normal)
        }
        
        if let originalImage = UIImage(named: "radio_button_on") {
            let imageSize = CGSize(width: btnfamily.frame.width, height: btnfamily
                .frame.height)
            let resizedImage = originalImage.resized(to: imageSize)
            btnfamily.setImage(resizedImage, for: .selected)
            btnnumber.setImage(resizedImage, for: .selected)
            btnlife.setImage(resizedImage, for: .selected)
        }
        //btnfamily.setImage(UIImage.init(named: "radio_button_off"), for: .normal)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(TapDelete))
        //直接用程式碼創建button
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnChoose(_ sender: UIButton) {
        if sender == btnlife
        {
            whichGame = "btnlife"
            btnlife.isSelected = true
            btnnumber.isSelected = false
            btnfamily.isSelected = false
        }
        else if sender == btnfamily
        {
            whichGame = "btnfamily"
            btnlife.isSelected = false
            btnnumber.isSelected = false
            btnfamily.isSelected = true
        }
        else
        {
            whichGame = "btnnumber"
            btnlife.isSelected = false
            btnnumber.isSelected = true
            btnfamily.isSelected = false
        }
            
        
    }
    @IBAction func gameStartAction(_ sender: Any) {
        
        
    }
    
    @objc private func TapDelete(){
        guard let singleuser = self.SingleUser else {
            return
        }
        realm.beginWrite()
        realm.delete(singleuser)
        try! realm.commitWrite()
        deletionHandler?()
        let vc =  self.navigationController?.viewControllers.filter({$0 is totalUserViewController}).first
        self.navigationController?.popToViewController(vc!, animated: true)
        
    }
    
    
    

}


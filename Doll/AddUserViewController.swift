//
//  AddUserViewController.swift
//  Doll
//
//  Created by 陳語安 on 2023/8/22.
//
import RealmSwift
import UIKit


var strarray = [String]()///
var count=0///
///
var str: String = ""

class AddUserViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var NFCtagShow: UILabel!///
    var simpleBluetoothIO: SimpleBluetoothIO!
    
    
    @IBOutlet weak var upload: UIButton!
    @IBOutlet weak var enterName: UITextField!
    
    
    
    
    
    private let realm = try! Realm()//開始新增或刪除資料庫需要這個

    public var completionHandler: (()-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        simpleBluetoothIO = SimpleBluetoothIO(serviceUUID: "4fafc201-1fb5-459e-8fcc-c5c9c331914b", delegate: self)
        //print("viewDidload")
        
        
        
        enterName.becomeFirstResponder()
        enterName.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "儲存", style: .done, target: self, action: #selector(uploadAction))
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterName.resignFirstResponder()
        return true
    }
    @objc func uploadAction(_ sender: Any) {
        
        if let text = enterName.text , !text.isEmpty{
            
            var tagname: String?
          
            
            print("..........")
            print("nfctagtext: \(NFCtagShow.text)")
            print("......")
            realm.beginWrite()//開始寫
            let newItem = elderlyInfo()
            newItem.name = text
            newItem.nfctag = str
            newItem.ownerUser = Owner_fromSingleUser
            
            print("adduser: \(Owner_fromSingleUser)")
            print("newItem.nfctag: \(newItem.nfctag)")
            realm.add(newItem)//新增
            
            try! realm.commitWrite()//提交
            completionHandler?()
            
            /*也可以這樣
             try! realm.write {
                realm.add(newItem)
             }
             */
            
            
            let  vc =  self.navigationController?.viewControllers.filter({$0 is CareViewController}).first

            self.navigationController?.popToViewController(vc!, animated: true)
            //navigationController?.popToViewController(CareViewController, animated: true)
            
            
            
            
        }
        else{
            print("Add something")
        }
        
        
    }
    

}
extension AddUserViewController: SimpleBluetoothIODelegate {
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, didReceiveValue value: Int8) {
            //view.backgroundColor = UIColor.yellow
            //virtualButton.setOn(false, animated: true)
        //print("function裏面")
        
        let stringValue = String(value)
        strarray.append(stringValue)
        //print(strarray)
        
        count=count+1
        
        if(count==7){
            print(strarray)
            
            //stringArray.joined(separator: "")

            str = strarray.joined(separator: "")
            NFCtagShow.text = str
            count=0
            strarray.removeAll()///change
           
        }
            //NFCtagNumber.text = str
            //var str = String(bytes: value, encoding: .utf8)!
            //NFCtagNumber.text = str
            
    }
}

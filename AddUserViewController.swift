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

class AddUserViewController: UIViewController, UITextFieldDelegate {
    
    
    
    
    var simpleBluetoothIO: SimpleBluetoothIO!///
    @IBOutlet weak var NFCtagShow: UILabel!///
    
    
    
    @IBOutlet weak var upload: UIButton!
    @IBOutlet weak var enterName: UITextField!
    
    
    
    
    
    private let realm = try! Realm()
    public var completionHandler: (()-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        simpleBluetoothIO = SimpleBluetoothIO(serviceUUID: "4fafc201-1fb5-459e-8fcc-c5c9c331914b", delegate: self)///
        
        
        
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
            realm.beginWrite()
            let newItem = elderlyInfo()
            newItem.item = text
            realm.add(newItem)
            try! realm.commitWrite()
            completionHandler?()
            
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
        let stringValue = String(value)
        strarray.append(stringValue)
        //print(strarray)
        
        count=count+1
        
        if(count==7){
            print(strarray)
            let str = strarray.joined(separator: ", ")
            NFCtagShow.text = str
            count=0
            strarray.removeAll()
        }
            //NFCtagNumber.text = str
            //var str = String(bytes: value, encoding: .utf8)!
            //NFCtagNumber.text = str
            
    }
}

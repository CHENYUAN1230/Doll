//
//  ViewController.swift
//  Doll
//
//  Created by 陳語安 on 2023/8/18.
//
import RealmSwift
import UIKit

class ViewController: UIViewController {

    private let realm = try! Realm()
    public var completionHandler: (()-> Void)?
   
    @IBOutlet weak var playbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func playaction(_ sender: Any) {
        let family = realm.objects(elderlyInfo.self).map({ $0 })
        if family.count > 0{
            let number = Int.random(in: 0..<family.count)
            print(family[number].item)
        }
        
        
    }
    

    
}


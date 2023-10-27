//
//  playViewController.swift
//  Doll
//
//  Created by 陳語安 on 2023/8/25.
//
import RealmSwift
import UIKit


class playViewController: UIViewController {

    
    @IBOutlet weak var gamelabel: UILabel!
    @IBOutlet weak var readybutton: UIButton!
    private let realm = try! Realm()
    public var completionHandler: (()-> Void)?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
             
            //该页面显示时强制横屏显示
        appDelegate.interfaceOrientations = [.landscapeLeft, .landscapeRight]
    }
    
    
    
    

    @IBAction func readyaction(_ sender: Any) {
        print("press")
        readybutton.setTitle("下一題", for: .normal)
        let family = realm.objects(elderlyInfo.self).map({ $0 })
        if family.count > 0{
            let number = Int.random(in: 0..<family.count)
            print(family[number].item)
            gamelabel.text = family[number].item
        }

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         
        //页面退出时还原强制竖屏状态
        appDelegate.interfaceOrientations = .portrait
    }
     
}

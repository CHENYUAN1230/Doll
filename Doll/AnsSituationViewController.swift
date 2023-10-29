//
//  AnsSituationViewController.swift
//  Doll
//
//  Created by 陳語安 on 2023/10/29.
//

import UIKit

var showRecord = "" //record資料庫要顯示哪個遊戲的



class AnsSituationViewController: UIViewController {

    
    @IBOutlet weak var btnlifeRecord: UIButton!
    
    @IBOutlet weak var btnfamilyRecord: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickLife(_ sender: Any) {
        showRecord = "btnlife"
    }
    
    @IBAction func clidkFamily(_ sender: Any) {
        showRecord = "btnfamily"
    }
    

}

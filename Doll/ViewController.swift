//
//  ViewController.swift
//  Doll
//
//  Created by 陳語安 on 2023/8/18.
// testlala
import RealmSwift
import UIKit

var Random = [Int]()

class ViewController: UIViewController {

    private let realm = try! Realm()
    public var completionHandler: (()-> Void)?
   
    @IBOutlet weak var playbutton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func randomquestion() -> [question]{
        var Question: [question] = []
        let family = realm.objects(elderlyInfo.self).map({ $0 })
        
        
        for i in 1...10{
            let number = Int.random(in: 0..<family.count)
            Question.append(number)
         
        }
        print(Question)
        
        return Question
        
    }
    
    
    
    
    
    @IBAction func playaction(_ sender: Any) {
        let family = realm.objects(elderlyInfo.self).map({ $0 })
        Random = randomquestion()
        
       
        
        
    }
    

    
}


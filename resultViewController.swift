//
//  resultViewController.swift
//  Doll
//
//  Created by 陳語安 on 2023/10/29.
//

import UIKit
import RealmSwift
class resultViewController: UIViewController {
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var wrongAnswerLabel: UILabel!
    private let realm = try! Realm()
    private var data = [record]()
    public var completionHandler: (()-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if whichGame != "btnnumber"
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss" // 定义日期时间的格式
            let date = Date() // 获取当前日期时间
            let formattedDate = dateFormatter.string(from: date)
            
            
            scoreLabel.text = String(finalScore)
            var newList : [String] = []
            print("________resultcontroller_____")
            print(finalScore)
            print(wrongAnswerList)
            
            /*
            for i in 0...wrongAnswerList.count-1
            {
                var repeatNumber = 1
                for j in i+1...wrongAnswerList.count-1
                {
                    if wrongAnswerList[i] == wrongAnswerList[j]
                    {
                        repeatNumber = repeatNumber + 1
                    }
                }
                wrongAnswerList.removeAll{ $0 == wrongAnswerList[i] } //重複的刪除
                if repeatNumber > 1 //錯超過一次
                {
                    newList.append("\(wrongAnswerList[i])*\(repeatNumber)")
                    
                }
                else
                {
                    newList.append(wrongAnswerList[i])
                }
            }*/
            
             var repeatCounts: [String: Int] = [:]

             for answer in wrongAnswerList {
                 if repeatCounts[answer] != nil {
                     // 如果字典中已经包含了这个答案，增加其出现次数
                     repeatCounts[answer]! += 1
                 } else {
                     // 否则，将答案添加到字典并初始化出现次数为1
                     repeatCounts[answer] = 1
                 }
             }

             // 遍历字典，输出每个答案和它的重复次数
             for item in wrongAnswerList {
                 if let count = repeatCounts[item], count > 1 {
                     newList.append("\(item):錯 \(count) 次")
                     // 避免重复添加相同的值
                     repeatCounts[item] = nil
                 } else {
                     newList.append("\(item)")
                 }
             }
            
            
            
            

            wrongAnswerLabel.text = newList.joined(separator: ",")
            realm.beginWrite()
            let newrecord = record()
            newrecord.gameType = whichGame
            newrecord.recordUser = Owner_fromSingleUser
            newrecord.score = String(finalScore)
            newrecord.wrongAnswer = newList.joined(separator: ",")
            newrecord.time = formattedDate
            realm.add(newrecord)
            try! realm.commitWrite()
            //completionHandler!()
        }
        else
        {
            
        }
        
        
        
        
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
             
            //该页面显示时强制横屏显示
        appDelegate.interfaceOrientations = [.landscapeLeft, .landscapeRight]
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         
        //页面退出时还原强制竖屏状态
        appDelegate.interfaceOrientations = .portrait
    }
    
    @IBAction func watchscore(_ sender: Any) {
        
        data = realm.objects(record.self).map({ $0})
        print("_______record data______")
        print(data)
    }
    
}

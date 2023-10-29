//
//  AnswerTableViewController.swift
//  Doll
//
//  Created by 陳語安 on 2023/10/29.
//

import UIKit
import RealmSwift

class AnswerTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var AnswerTable: UITableView!
    
    private let realm = try!Realm()
    private var data = [record]()
    
    var displayedData = [record]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(record.self).map({ $0})
        setupDisplayedData()
        AnswerTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        AnswerTable.delegate = self
        AnswerTable.dataSource = self
       
    }
    func setupDisplayedData() {
        displayedData.removeAll() // 清空之前的数据
        for item in data {
            if (item.recordUser == Owner_fromSingleUser && item.gameType == showRecord) {
                displayedData.append(item)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let combin = displayedData[indexPath.row].time + displayedData[indexPath.row].score + displayedData[indexPath.row].wrongAnswer
        
        //顯示遊玩時間和分數
        cell.textLabel?.text = combin
        return cell
    }
    func refresh(){
        data = realm.objects(record.self).map({ $0 })
        setupDisplayedData()
        AnswerTable.reloadData()
    }


    
}

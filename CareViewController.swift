//
//  CareViewController.swift
//  Doll
//
//  Created by 陳語安 on 2023/8/22.
//

import UIKit
import RealmSwift



class elderlyInfo: Object {
    @objc dynamic var item: String = ""
    
}

class familymember {
    static let shared = familymember()
    var family = [Int]()
    
    private init(){}
}

class CareViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var table: UITableView!
    
    private let realm = try! Realm()
    private var data = [elderlyInfo]()
    

    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(elderlyInfo.self).map({ $0 })
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    // Mark: Table
    //_ tableView: 外部參數 內部參數（此沒有外部參數）
    //Tells the data source to return the number of rows in a given section of a table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // ->Int 回傳值為int
        
        return data.count //有幾條data就有多少row
    }
    
    //一個cell代表一項item
    //每一筆資料的內容
    //Asks the data source for a cell to insert in a particular location of the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        /* dequeue 等於「to remove from a queue」，也就是從佇列中移出的意思。當我們在手機上向下滑動時，此時 UITableView 為了要顯示下一個 UITableViewCell，它會將即將要消失的UITableViewCell(最上面的) 移出佇列給即將要顯示的 UITableViewCell(最下面) 使用，而不是一直產生新的物件。*/
        cell.textLabel?.text = data[indexPath.row].item   //?:如果一個變數或常數可能收到nil，該變數或常數的資料型態必須宣告為Optimal型態

        return cell
    }
    
    //選中後要做的事
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Open the screen where we can see item info and delete
        let item = data[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(identifier: "personalINFO") as?  personalINFOViewController else{
            return
        }
        
        
        
        
        
        
        vc.item = item
        vc.deletionHandler = {[weak self] in self?.refresh()
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = item.item
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapAddButton(){
        guard let vc = storyboard?.instantiateViewController(identifier: "upload") as? AddUserViewController else{
            return
        }
        vc.completionHandler = { [weak self] in self?.refresh()}
        vc.title = "新增使用者"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    func refresh(){
        data = realm.objects(elderlyInfo.self).map({ $0 })
        table.reloadData()
    }

}

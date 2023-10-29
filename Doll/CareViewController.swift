//
//  CareViewController.swift
//  Doll
//
//  Created by 陳語安 on 2023/8/22.
//

import UIKit
import RealmSwift



class CareViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    //@IBOutlet weak var test: UIBarButtonItem!
    
    @IBOutlet var table: UITableView!
    //@IBOutlet var testbutton: UIButton!
    
    private let realm = try! Realm()
    private var data = [elderlyInfo]()
    
    var displayedData = [elderlyInfo]()

    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(elderlyInfo.self).map({ $0 })
        setupDisplayedData()
        print("displayData.count: \(displayedData.count)")
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //table.register(UITableViewCell.self, forCellReuseIdentifier: "emptycell")
        table.delegate = self
        table.dataSource = self
        
       
        // Do any additional setup after loading the view.
    }
    func setupDisplayedData() {
        displayedData.removeAll() // 清空之前的数据
        for item in data {
            if item.ownerUser == Owner_fromSingleUser {
                displayedData.append(item)
            }
        }
    }

    // Mark: Table
    //_ tableView: 外部參數 內部參數（此沒有外部參數）
    //Tells the data source to return the number of rows in a given section of a table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // ->Int 回傳值為int
        
        /*/
        if(data[indexPath.row].ownerUser == Owner_fromSingleUser)
        {
            var Count = data
        }*/
        return displayedData.count //有幾條data就有多少row
    }
    
    //一個cell代表一項item
    //每一筆資料的內容
    //Asks the data source for a cell to insert in a particular location of the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        /* dequeue 等於「to remove from a queue」，也就是從佇列中移出的意思。當我們在手機上向下滑動時，此時 UITableView 為了要顯示下一個 UITableViewCell，它會將即將要消失的UITableViewCell(最上面的) 移出佇列給即將要顯示的 UITableViewCell(最下面) 使用，而不是一直產生新的物件。*/
        
        print("careView: \(Owner_fromSingleUser)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = displayedData[indexPath.row].name
        return cell
        
        //?:如果一個變數或常數可能收到nil，該變數或常數的資料型態必須宣告為Optimal型態
        
        
    }
    
    //選中後要做的事
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Open the screen where we can see item info and delete
        let  Item = displayedData[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(identifier: "personalINFO") as?  personalINFOViewController else{
            return
        }
        
        
        vc.Item = Item //vc.Item定義在personalINFO
        vc.deletionHandler = {[weak self] in self?.refresh()}
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = Item.name
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapAddButton(){
        
        
        guard let vc = storyboard?.instantiateViewController(identifier: "upload") as? AddUserViewController else{
            return
        }
        vc.completionHandler = { [weak self] in self?.refresh()}
        vc.title = "新增家人"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        print("hellooooooo")
    }
    
    
    func refresh(){
        data = realm.objects(elderlyInfo.self).map({ $0 })
        setupDisplayedData()
        table.reloadData()
    }

}

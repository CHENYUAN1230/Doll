//
//  totalUserViewController.swift
//  Doll
//
//  Created by 陳語安 on 2023/9/21.
//

import UIKit
import RealmSwift

class totalUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userTable: UITableView!
    
    private let realm = try! Realm()
    private var user = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = realm.objects(User.self).map({ $0 })
        userTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        userTable.delegate = self
        userTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        cell.textLabel?.text = user[indexPath.row].username
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Open the screen where we can see item info and delete
        let  Item = user[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(identifier: "singleUser") as?  singleUserViewController else{
            return
        }
        
        
        vc.SingleUser = Item
        vc.deletionHandler = {[weak self] in self?.refresh()}
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = Item.username
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func adduser(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "addNewUser") as? addNewUserViewController else{
            return
        }
        vc.completionHandler = { [weak self] in self?.refresh()}
        vc.title = "新增使用者"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func refresh(){
        user = realm.objects(User.self).map({ $0 })
        userTable.reloadData()
    }

    

}

//
//  personalINFOViewController.swift
//  
//
//  Created by 陳語安 on 2023/8/22.
//
import RealmSwift
import UIKit

class personalINFOViewController: UIViewController {

    public var Item: elderlyInfo?
    public var deletionHandler: (()-> Void)?
    
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet weak var tagnumberlabel: UILabel!
    
    private let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        itemLabel.text = Item?.name
        tagnumberlabel.text = Item?.nfctag
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))

        // Do any additional setup after loading the view.
    }
    
    @objc private func didTapDelete(){
        guard let myItem = self.Item else {
            return
        }
        realm.beginWrite()
        realm.delete(myItem)
        try! realm.commitWrite()
        deletionHandler?()
        let  vc =  self.navigationController?.viewControllers.filter({$0 is CareViewController}).first

        self.navigationController?.popToViewController(vc!, animated: true)
    }
    



}

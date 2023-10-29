//
//  Database.swift
//  Doll
//
//  Created by 陳語安 on 2023/9/21.
//

import RealmSwift

class User: Object {
    @objc dynamic var username = ""
    @objc dynamic var profileImage: Data? = nil
    let games = List<Game>()
}

class Game: Object {
    @objc dynamic var gamename = ""
    let familyMembers = List<elderlyInfo>()
}

class elderlyInfo: Object {
    @objc dynamic var name = ""
    @objc dynamic var nfctag: String = ""
    @objc dynamic var ownerUser = ""
    let owner = LinkingObjects(fromType: Game.self, property: "familyMembers")
}


class record: Object{
    @objc dynamic var gameType = ""
    @objc dynamic var recordUser = ""
    @objc dynamic var score = ""
    @objc dynamic var wrongAnswer = ""
    @objc dynamic var time = ""
}//修改資料庫



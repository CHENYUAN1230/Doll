//
//  playViewController.swift
//  Doll
//
//  Created by 陳語安 on 2023/8/25.
//testttttt
import RealmSwift
import UIKit
import AVFoundation

var playarray = [String]()///
var count2=0///

var str2: String = ""
//var Random = randomquestion()
//var random = [String]()

typealias question = Int
var wrongAnswerList : [String] = []//紀錄錯誤的題目
var finalScore = 100


class playViewController: UIViewController {
    var simpleBluetoothIO: SimpleBluetoothIO!
    
    @IBOutlet weak var gamelabel: UILabel!
    @IBOutlet weak var readybutton: UIButton!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var QuestionNumberLabel: UILabel!
    private let realm = try! Realm()
    public var completionHandler: (()-> Void)?
    var questionNumber = -1
    
    var Question: [Int] = []
    let LifeArray = AppConstants.lifeArray
    var correct : [String] = []
    var len = 0
    
    var data = [elderlyInfo]()
    
    var displayedData = [elderlyInfo]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var pressnumber = 0
    var correctOrNot = true//答對才可以下一題
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        simpleBluetoothIO = SimpleBluetoothIO(serviceUUID: "4fafc201-1fb5-459e-8fcc-c5c9c331914b", delegate: self)
        // Do any additional setup after loading the view.
        
        
        //print("data:\(data[0].name)")
        
        
        
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "result" { // 替换成你的 segue 标识符
            if let resultVC = segue.destination as? resultViewController {
                resultVC.finalScore = finalScore
                resultVC.wrongAnswerList = wrongAnswerList
            }
        }
    }*/
    
    


    func setupDisplayedData() {
        displayedData.removeAll() // 清空之前的数据
        for item in data {
            if item.ownerUser == Owner_fromSingleUser {
                displayedData.append(item)
                print("有沒有進來")
                print(item)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
             
            //该页面显示时强制横屏显示
        appDelegate.interfaceOrientations = [.landscapeLeft, .landscapeRight]
    }
    
    
    //let Random = randomquestion()
    
    
    
    @IBAction func readyaction(_ sender: Any) {
        
        if correctOrNot == true
        {
            
            correctOrNot = false
            questionNumber = questionNumber + 1
            QuestionNumberLabel.text = "\(questionNumber + 1)/10"
            print("questionNumber: \(questionNumber)")
            
            pressnumber = 0
            correct.removeAll()  //下一題時清空correct list
            
            if questionNumber < 10
            {
                if whichGame == "btnfamily"
                {
                    
                    simpleBluetoothIO.writeValue(value: 52) //char : 4
                    data = realm.objects(elderlyInfo.self).map({ $0 })
                    setupDisplayedData()
                    
                    for i in 1...10{
                        let number = Int.random(in: 0..<displayedData.count)
                        Question.append(number)
                        
                    }
                    //print(displayedData[Question[questionNumber]].name)
                    gamelabel.text = ""
                    QuestionLabel.text = displayedData[Question[questionNumber]].name
                }
                else if whichGame == "btnlife"
                {
                    simpleBluetoothIO.writeValue(value: 52) //char : 4
                    for i in 1...10{
                        let number = Int.random(in: 0..<2)
                        Question.append(number)
                    }
                    
                    gamelabel.text = ""
                    QuestionLabel.text = LifeArray[Question[questionNumber]][0]
                    len = LifeArray[Question[questionNumber]].count
                    for item in LifeArray[Question[questionNumber]]
                    {
                        print(item)
                    }
                }
                else
                {
                    simpleBluetoothIO.writeValue(value: 51) //char : 3
                    
                    for i in 1...10{
                        let number = Int.random(in: 1..<10)
                        Question.append(number)
                    }
                    gamelabel.text = ""
                    QuestionLabel.text = "請按\(Question[questionNumber])下"
                }
                
                readybutton.setTitle("下一題", for: .normal)
            }
            else if questionNumber == 10
            {
                readybutton.setTitle("結束", for: .normal)
                QuestionLabel.text = ""
                QuestionNumberLabel.text = ""
                gamelabel.text = "恭喜完成了！"
                playSound(SoundNane: "恭喜完成")
                correctOrNot = true
                
            }
            else
            {
                simpleBluetoothIO.writeValue(value: 53) //char : 5
                
                if let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "result") as? resultViewController {
                        // 使用导航控制器来切换到 resultViewController
                        self.navigationController?.pushViewController(resultVC, animated: true)
                    }
                
            }
        }
        
      
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         
        //页面退出时还原强制竖屏状态
        appDelegate.interfaceOrientations = .portrait
    }
     
}
var audioPlayer: AVAudioPlayer?
func playSound(SoundNane:String) {
    

    if let path = Bundle.main.path(forResource: SoundNane, ofType: "m4a") {
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            print(url)
        } catch {
            // 处理音频加载错误
            print("Error loading audio file")
        }
        
    }
    else
    {
        print("找不到音檔")
    }
    audioPlayer?.play()
    audioPlayer?.volume = 1
    
}
extension playViewController: SimpleBluetoothIODelegate {
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, didReceiveValue value: Int8) {
        
        
        //還沒按readybutton就感應會出錯
        if whichGame == "btnfamily"//家人遊戲
        {
           
            //let family2 = realm.objects(elderlyInfo.self).map({ $0 })
            //Random = randomquestion()
        
           
            print("value: \(value)")
            let strValue = String(value)
            playarray.append(strValue)
            
            count2=count2+1
            
            if(count2==7)
            {
                print("questionNumber: \(questionNumber)")
                print(playarray)
                str2 = playarray.joined(separator: "")
                count2=0
                playarray.removeAll()///change
                print("str2:\(str2)")
                print("displayedData[Random[questionNumber]].nfctag:\(displayedData[Question[questionNumber]].nfctag)")
                if(str2 == displayedData[Question[questionNumber]].nfctag)
                {
                    correctOrNot = true
                    gamelabel.text = "答對了🥳"
                    playSound(SoundNane: "答對了～很棒欸")
                    simpleBluetoothIO.writeValue(value: 50)
                    
                }
                else
                {
                    correctOrNot = false
                    gamelabel.text = "答錯了🥹"
                    playSound(SoundNane: "答錯了～再試試看")
                    //simpleBluetoothIO.writeValue(value: 77)
                    wrongAnswerList.append(displayedData[Question[questionNumber]].name)
                    
                    finalScore = finalScore - 10
                }
                
            }
        }
        else if(whichGame == "btnlife")//生活遊戲
        {
            
            let strValue = String(value)
            playarray.append(strValue)
            
            count2=count2+1
            
            if(count2==7)
            {
                print("questionNumber: \(questionNumber)")
                print(playarray)
                str2 = playarray.joined(separator: "")
                count2=0
                playarray.removeAll()///change
                print("str2:\(str2)")
                
                
                if correct.count<3
                {
                    
                    
                    var match = false
                    for item in LifeArray[Question[questionNumber]]
                    {
                        
                        if str2 == item
                        {
                            match = true
                            print(correct)
                            if correct.count == 0
                            {
                                correctOrNot = false
                                correct.append(item)
                                print("答對了，還有嗎")
                                gamelabel.text = "答對了，還有嗎"
                                playSound(SoundNane: "答對了～還有嗎")
                                simpleBluetoothIO.writeValue(value: 50)
                                
                                QuestionLabel.text = LifeArray[Question[questionNumber]][0]
                            }
                            /*
                             else if correct.count >= 3
                             {
                             correctOrNot = true
                             print("全對了，請下一題")
                             gamelabel.text = "全對了，請下一題"
                             playSound(SoundNane: "全對")
                             simpleBluetoothIO.writeValue(value: 50)
                             QuestionLabel.text = LifeArray[Question[questionNumber]][0]
                             }*/
                            else
                            {
                                for i in 0...correct.count-1
                                {
                                    if(item == correct[i])
                                    {
                                        correctOrNot = false
                                        print("重複摟，還有嗎")
                                        gamelabel.text = "重複摟，還有嗎"
                                        playSound(SoundNane: "重複")
                                        simpleBluetoothIO.writeValue(value: 50)
                                        QuestionLabel.text = LifeArray[Question[questionNumber]][0]
                                        break
                                    }
                                    else if (i == correct.count-1)
                                    {
                                        correct.append(item)
                                        if correct.count == 3
                                        {
                                            correctOrNot = true
                                            print("全對了，請下一題")
                                            gamelabel.text = "全對了，請下一題"
                                            playSound(SoundNane: "全對")
                                            simpleBluetoothIO.writeValue(value: 50)
                                            QuestionLabel.text = LifeArray[Question[questionNumber]][0]
                                        }
                                        else
                                        {
                                            correctOrNot = false
                                            print("答對了，還有嗎")
                                            gamelabel.text = "答對了，還有嗎"
                                            playSound(SoundNane: "答對了～還有嗎")
                                            simpleBluetoothIO.writeValue(value: 50)
                                            QuestionLabel.text = LifeArray[Question[questionNumber]][0]
                                        }
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    if match == false //correct list 都比對過後，沒有match才會跑到這裡
                    {
                        correctOrNot = false
                        print("答錯了，再試試看")
                        gamelabel.text = "答錯了，再試試看"
                        playSound(SoundNane: "答錯了～再試試看")
                        QuestionLabel.text = LifeArray[Question[questionNumber]][0]
                        wrongAnswerList.append(LifeArray[Question[questionNumber]][0])
                        print(wrongAnswerList)
                        finalScore = finalScore - 10
                    }
                }
                else//已經答對了，繼續感應tag只會顯示全對
                {
                    correctOrNot = true
                    print("全對了，請下一題")
                    gamelabel.text = "全對了，請下一題"
                    playSound(SoundNane: "全對")
                    simpleBluetoothIO.writeValue(value: 50)
                    QuestionLabel.text = LifeArray[Question[questionNumber]][0]
                }
                
            }
            
        }
        else//數字遊戲
        {
            
            print(value)
            
            if(String(value) == "1")
            {
                pressnumber = pressnumber + 1
                if pressnumber < Question[questionNumber]
                {
                    correctOrNot = false
                    playSound(SoundNane: "\(pressnumber)")
                }
                
                gamelabel.text = String(pressnumber)
                if pressnumber == Question[questionNumber]
                {
                    correctOrNot = true
                    gamelabel.text = "答對了🥳"
                    playSound(SoundNane: "答對了～很棒欸")
                    simpleBluetoothIO.writeValue(value: 50)
                }
                else if pressnumber > Question[questionNumber]
                {
                    correctOrNot = true
                    gamelabel.text = "全對了，請下一題"
                    playSound(SoundNane: "全對")
                    //simpleBluetoothIO.writeValue(value: 50)
                }
            }
            //gamelabel.text = String(value)
            
            
        }
        
        
        
        
        
    }
}

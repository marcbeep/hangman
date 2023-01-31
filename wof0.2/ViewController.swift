//
//  ViewController.swift
//  wof
//
//  Created by Marc Beepath on 11/11/2022.
//

import UIKit

struct phrases: Codable{
    let genre: String
    let list: [String]
}

class ViewController: UIViewController {
    
    var phraseFound = false
    var wheelSpun = false
    var points = 0
    var s = 0
    var hs = 0
    var guessCount = 0
    var errors = ""
    var phrase = ""
    var phraseChecker = ""
    var blocked = ""
    var blockedArr = [Character]()
    var guessLetter: Character = "a"
    var phraseArr = [Character]()
    
    @IBOutlet weak var displayPhrase: UILabel!
    @IBOutlet weak var guessField: UITextField!
    
    @IBOutlet weak var pointLabel: UILabel!
    
    @IBAction func guessButton(_ sender: Any) {
        
        if(wheelSpun==false){
            
            // SPIN WHEEL FIRST ALERT
            let dialogMessage = UIAlertController(title: "🤪", message: "Spin the wheel first!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                //print("Ok button tapped")
             })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            
        }else{
            if guessField.text!.count > 1 || guessField.text! == ""{
                // INCORRECT TEXT FIELD
                let dialogMessage = UIAlertController(title: "😱", message: "Only single letters allowed", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    //print("Ok button tapped")
                 })
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
            }else{
                guessLetter = Character(guessField.text!.uppercased())
                checkCorrect()
                //wheelSpun = false
                guessField.text = ""
            }

        }
    }
    
    @IBAction func spinButton(_ sender: Any) {
        if wheelSpun != true {
            let pointArr = [01, 02, 05, 10, 20]
            points = pointArr.randomElement()!
            pointLabel.text = String(points)
            wheelSpun = true
        }
    }
    
    @IBOutlet weak var incorrectLabel: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var highscore: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var triesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incorrectLabel.text = ""
        start()
        // Do any additional setup after loading the view.
    }
    
    func start(){
        s = 0
        points = 0
        guessCount = 0
        triesLabel.text = "Remaining: 10"
        incorrectLabel.text = ""
        errors = ""
        score.text = "Score: \(s)"
        phrase = ""
        phraseChecker = ""
        blocked = ""
        blockedArr = []
        guessLetter = "a"
        phraseArr = []
        
        getPhrase()
        getBlocked()
        loadHighScore()
    }
    
    func getPhrase(){
        
        let genreList = ["Classic Books", "Classic Movies", "TV Shows"]
        let genre = genreList.randomElement()!
        categoryLabel.text=genre
        
        guard let path = Bundle.main.path(forResource: genre, ofType: "json")else{
            fatalError("File not found")
        }
        guard let readFile = try? String(contentsOf: URL(fileURLWithPath: path), encoding: String.Encoding.utf8) else{
            return
        }
        
        var fileDetails: phrases?
        do{
            fileDetails = try JSONDecoder().decode(phrases.self, from: Data(readFile.utf8))
        }catch{
            print("Error")
        }
        
        phrase = (fileDetails?.list.randomElement()!)!
        print("\(genre) : \(phrase)")
        phrase = phrase.uppercased()
        phraseArr = Array(phrase)
        //displayPhrase.text = phrase
    }
    
    func getBlocked(){
        for i in phrase{
            
            if i == " "{
                blocked += "\n"
                phraseChecker += "\n"
            }else{
                blocked += "⬛️"
                phraseChecker += String(i)
            }
            
        }
        blockedArr = Array(blocked)
        displayPhrase.text = String(blockedArr)
    }
    
    func alreadyGuessed(){
        
        // ALERT MESSAGE
        let dialogMessage = UIAlertController(title: "🤕", message: "You've already entered that letter", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            //print("Ok button tapped")
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    func checkCorrect(){
        if blockedArr.contains(guessLetter)==false{
            
            for i in 0...phrase.count-1{
                if phraseArr.contains(guessLetter){
                    wheelSpun = false
                    if guessLetter == phraseArr [i]{
                        blockedArr[i] = guessLetter
                        //print(blockedArr)
                        //print("\(guessLetter) CORRECT")
                        pointLabel.text = "⬅️"
                        displayPhrase.text = String(blockedArr)
                        incrementScore()
                    }
                }
            }
        }
        else{
            //print("\(guessLetter) ALREADY GUESSED")
            alreadyGuessed()
        }
        
        if phraseArr.contains(guessLetter)==false{
            
            if errors.contains(guessLetter){
                //print("\(guessLetter) INCORRECT")
                
                alreadyGuessed()
                
            }else{
                wheelSpun = true
                errors.append("❌\(guessLetter) ")
                incorrectLabel.text = errors
                guessCount+=1
                triesLabel.text = "Remaining: \(10-guessCount)"
                if(guessCount>=10){
                    performSegue(withIdentifier: "toPopup", sender: nil)
                }
            }
        }
        
        found()
    }
    
    func incrementScore(){
        s+=points
        score.text = "Score: \(s)"
        
        if(s>hs){
            hs = s
            UserDefaults.standard.set(hs, forKey: "hs")
            loadHighScore()
        }
    }
    
    func loadHighScore(){
        hs = UserDefaults.standard.integer(forKey: "hs")
        highscore.text = "Highscore: \(hs)"
    }
    
    func found(){
        
        //print(Array(phraseChecker))
        //print(blockedArr)
        
        if(Array(phraseChecker) == blockedArr){
            phraseFound = true
            performSegue(withIdentifier: "toPopup", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPopup"{
            let data = segue.destination as! popup
            data.correctPhrase = phrase
            if phraseFound == true{
                data.congrats = "Winner Winner Chicken Dinner 🎉"
            }else{
                data.congrats = "You lost. That's too bad 🤷‍♀️"
            }
            data.scoreMessage = "You've scored \(s) points"
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        start()
    }
    
}


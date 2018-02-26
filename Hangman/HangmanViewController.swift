//
//  HangmanViewController.swift
//  Hangman
//
//  Created by Winston Jiang on 2/20/18.
//  Copyright © 2018 iOS DeCal. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var counterDisp: UILabel!
    @IBOutlet weak var charInput: UITextField!
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var _displayer: UILabel!
    @IBOutlet weak var wrongCounter: UILabel!
    @IBOutlet weak var hangImage: UIImageView!
    @IBOutlet weak var newGame: UIButton!
    
    @IBOutlet weak var background: UIImageView!
    
    var displayArray = [String]()
    let hangState: [UIImage] = [#imageLiteral(resourceName: "hangman1.png"),#imageLiteral(resourceName: "hangman2.png"),#imageLiteral(resourceName: "hangman3.png"),#imageLiteral(resourceName: "hangman4.png"),#imageLiteral(resourceName: "hangman5.png"),#imageLiteral(resourceName: "hangman6.png"),#imageLiteral(resourceName: "hangman7.png")]
    var hangStateNum: Int = 0
    var game: HangmanGame!
    var randomWord: String = ""

    var gameState = true
    
    var guessArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeNewGame()
        
        self.view.backgroundColor = UIColor.cyan
        background.image = #imageLiteral(resourceName: "background.jpg")
        view.sendSubview(toBack: background)

        newGame.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 40)
        guessButton.setTitle("Guess", for: .normal)
        counterDisp.text = "Incorrect Guesses: "
        wrongCounter.text = guessArray.joined(separator: " ")

        // Do any additional setup after loading the view.
        newGame.setTitle("Start Over", for: .normal)
        self.charInput.delegate = self
    }

    func makeWinAlert() {
        let winAlert = UIAlertController(title: "Congratulations!", message: "You won!!!", preferredStyle: .alert)
        
        let winAction = UIAlertAction(title: "New Game", style: .default) { (action:UIAlertAction) in
            //start new game
            self.makeNewGame()
        }
        winAlert.addAction(winAction)
        present(winAlert, animated: true, completion: nil)
    }
    
    func makeLoseAlert() {
        let loseAlert = UIAlertController(title: "Aw!", message: "You lost!!!", preferredStyle: .alert)
        let loseAction = UIAlertAction(title: "I'll do better next time.", style: .default)
        loseAlert.addAction(loseAction)
        present(loseAlert, animated: true, completion: nil)
    }

    //hide all icons on board, RESET ALL VALUES (including random word string)
    func gameOver() {
        
        //change icon hide/show
        newGame.isHidden = false
        counterDisp.isHidden = true
        charInput.isHidden = true
        guessButton.isHidden = true
        _displayer.isHidden = true
        wrongCounter.isHidden = true
        hangImage.isHidden = true

    }
    
    //show all icons on board, GENERATE NEW RANDOM WORD
    func makeNewGame() {

        //reset all values
        self.game = HangmanGame()
        displayArray.removeAll()
        guessArray.removeAll()
        hangStateNum = 0

        randomWord = ""
        //select random word, display it
        randomWord = game.getRandomWord()
        displayWord(word: randomWord)

        _displayer.text = displayArray.joined(separator: " ")
        wrongCounter.text = guessArray.joined(separator: " ")

        hangStateNum = 0
        hangImage.image = hangState[hangStateNum]

        wrongCounter.text = String(hangStateNum)
        hangImage.image = hangState[hangStateNum]
        
        //reveal/hide
        newGame.isHidden = true
        counterDisp.isHidden = false
        charInput.isHidden = false
        guessButton.isHidden = false
        _displayer.isHidden = false
        wrongCounter.isHidden = false
        hangImage.isHidden = false

    }

    @IBAction func newGameClick(_ sender: Any) {
        makeNewGame()
    }
    
    func displayWord(word: String) {
        for char in word {
            if (char == " ") {
                displayArray.append(" ")
            } else {
                displayArray.append("_")
            }
        }
    }
    
    func guessDisplayWord(char: Character) {
        var num = 0
        for i in randomWord {
            if (i == char) {
                displayArray[num] = String(char)
            }
            num += 1
        }
    }


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedChars = CharacterSet.letters
        let charSet = CharacterSet(charactersIn: string)
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return allowedChars.isSuperset(of: charSet) && newLength <= 10
        }



    @IBAction func clicked(_ sender: Any) {
        if (charInput.text!.count == 1) {
            let input = String(describing: charInput.text!)
            print(input)
            print(randomWord)
            //check if guess is wrong
            if (randomWord.range(of:input) != nil) {
                var num = 0
                for i in randomWord {
                    if (i == Character(charInput.text!)) {
                        displayArray[num] = input
                    }
                    _displayer.text = displayArray.joined(separator: " ")
                    num += 1
                }
            } else if (hangStateNum != hangState.count){
                //only increase if guess is wrong
                hangStateNum += 1
                if (!guessArray.contains(input)) {
                    guessArray.append(input)
                }
                wrongCounter.text = guessArray.joined(separator: " ")
                hangImage.image = hangState[hangStateNum]
            }
            if (hangStateNum == (hangState.count - 1)) {
                gameOver()
                makeLoseAlert()
            } else if (!displayArray.contains("_")) {
                gameOver()
                makeWinAlert()
            }
            charInput.text = ""
        } else {
            charInput.text = ""

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

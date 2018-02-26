//
//  HangmanGame.swift
//  Hangman
//
//  Created by Winston Jiang on 2/20/18.
//  Copyright © 2018 iOS DeCal. All rights reserved.
//

import UIKit

class HangmanGame {
    
    //var guessWord: String
    var randomWord: String
    
    init() {
        let hangmanPhrases = HangmanPhrases()
        let phrase: String = hangmanPhrases.getRandomPhrase()
        self.randomWord = phrase
    }
    
    
    func getRandomWord() -> String {
        return self.randomWord
    }
    
}

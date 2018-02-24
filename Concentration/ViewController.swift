//
//  ViewController.swift
//  Concentration
//
//  Created by Macaulay-Reiss Christian on 22/01/2018.
//  Copyright © 2018 Macaulay-Reiss Christian. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    private lazy var game = Concentration(numberOfPairsOfCards: numbersOfPairsOfCards)
    
    var numbersOfPairsOfCards: Int {
        // Read Only Property
            return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 { didSet { updateFlipCountLabel() } }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private(set) var scoreCount = 0 { didSet { updateScoreLabel() } }
    
    private func updateScoreLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Score:  \(scoreCount)", attributes: attributes)
        scoreLabel.attributedText = attributedString
    }

    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var flipCountLabel: UILabel! { didSet { updateFlipCountLabel() } }
    
    @IBOutlet private weak var scoreLabel: UILabel! { didSet { updateScoreLabel() } }
    
    @IBAction private func newGameButton(_ sender: UIButton) {
        self.refreshView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshView()
    }
    
    private func refreshView() {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        updateViewFromModel()
        setTheme()
    }

    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        scoreCount = game.score
        flipCount = game.flipCount
    }
    
    private let emojiThemes = [
        0: ["🦇","😱","🙀","😈","🎃","👻","🍭","🍬","🍎"],
        1: ["🍑","🍉","🍌","🍍","🥥","🥝","🍒","🍐","🍅"],
        2: ["🏏","🏑","🏓","🥊","🏀","⚽️","🏈","🏹","⛳️"],
        3: ["🐖","🐓","🐑","🦒","🦖","🦄","🐿","🦆","🐫"],
        4: ["🚗","🚕","🚜","🏎","🚓","🚒","🚛","🚑","🚎"],
        5: ["🇨🇦","🇧🇪","🇬🇧","🇺🇸","🇹🇷","🇪🇺","🇦🇺","🇫🇷","🇯🇵"],
    ]
    
    private var emojiChoices = [String]()
    private var emoji = [Card:String]()
    
    private func setTheme() {
        let theme = Int(arc4random_uniform(UInt32(emojiThemes.keys.count)))
        if let selectedTheme = emojiThemes[theme] {
            emojiChoices = selectedTheme
        } else {
            print ("Failed")
        }
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

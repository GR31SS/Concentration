//
//  Concentration.swift
//  Concentration
//
//  Created by Macaulay-Reiss Christian on 23/01/2018.
//  Copyright © 2018 Macaulay-Reiss Christian. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    
    var score = 0
    var flipCount = 0
    var indexOfOneAndOnlyFaceUpCard: Int?
    var previouslyFlippedCard = [Int]()
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                previouslyFlippedCard.append(matchIndex)
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else if previouslyFlippedCard.contains(cards[matchIndex].identifier) {
                    if score == 0 {
                        score = 0
                    } else {
                        score -= 1
                    }
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil    // not one and only ...
            } else {
                // either no card or two cards face up
                for flipdownIndex in cards.indices {
                    cards[flipdownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        flipCount += 1
    }
    
    init(numberOfPairsOfCards: Int) {
        var standardDeck = [Card]()
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            standardDeck += [card, card]
        }
        while standardDeck.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(standardDeck.count)))
            let randomCard = standardDeck.remove(at: randomIndex)
            cards.append(randomCard)
        }
    }
    
}

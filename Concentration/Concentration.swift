//
//  Concentration.swift
//  Concentration
//
//  Created by Macaulay-Reiss Christian on 23/01/2018.
//  Copyright © 2018 Macaulay-Reiss Christian. All rights reserved.
//

import Foundation

struct Concentration {
    
    private(set) var cards = [Card]()
    
    var score = 0
    var flipCount = 0
    
    // Computed Property
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }
            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private var previouslyFlippedCard = [Int]()
    
    mutating func chooseCard(at index: Int) {
        // Crashes program if index not correct
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                previouslyFlippedCard.append(matchIndex)
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else if previouslyFlippedCard.contains(matchIndex){
                    if score == 0 {
                        score = 0
                    } else {
                        score -= 1
                    }
                }
                cards[index].isFaceUp = true
            } else {
                // either no card or two cards face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        flipCount += 1
    }
    
    init(numberOfPairsOfCards: Int) {
        // Crashes program if 0 pairs of cards are detected
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): You must have at least one pair of cards.")
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

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

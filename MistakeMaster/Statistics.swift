//
//  Statistics.swift
//  MistakeMaster
//
//  Created by 3 Kings on 7/29/25.
//

import Foundation
import SwiftUI

struct Stats: Hashable {
//    @AppStorage("totalCorrect") static var totalCorrect: Int = 0
//    @AppStorage("totalIncorrect") static var totalIncorrect: Int = 0
//    @AppStorage("topMisconceptions") static var topMisconceptions: [String] = []
    
    var answersCorrect: Int = 0
    var answersIncorrect: Int = 0
    var misconceptionsAddressed: [Misconception] = []
    var secondsElapsed: Int = 0
    
    mutating func tallyCorrectAnswer() {
        answersCorrect += 1
    }
    
    mutating func tallyIncorrectAnswer() {
        answersIncorrect += 1
    }
    
    mutating func setSecondsElapsed(_ time: Int) {
        secondsElapsed = time
    }
    
    func getSecondsElapsed() -> Int {
        return secondsElapsed
    }
    
    func getTimeFormatted() -> String {
        return String(format: "%d:%02d", secondsElapsed / 60, secondsElapsed % 60)
    }
    
    func getScoreFac() -> Double {
        return (answersCorrect + answersIncorrect == 0) ? 0 : (Double(answersCorrect) / Double(answersIncorrect + answersCorrect))
    }
    
    func getAnswersCorrect() -> Int {
        return answersCorrect
    }
    
    func getAnswersIncorrect() -> Int {
        return answersIncorrect
    }
    
    func getTotalAnswers() -> Int {
        return answersCorrect + answersIncorrect
    }
}

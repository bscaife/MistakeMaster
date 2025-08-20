//
//  ChapterInfo.swift
//  MistakeMaster
//
//  Created by Ben Scaife on 7/27/25 for MistakeMaster.
//

import Foundation

struct UnitInfo: Codable {
    var name: String = ""
    var adjustedName: String = ""
    var path: String = ""
    var highestScoreDiagnostic: Double = 0.0
    var highestScoreChallenge: Double = 0.0
    var totalTime: Int = 0
    
    func getName() -> String {
        return name
    }
    
    func getAdjustedName() -> String {
        return adjustedName
    }
    
    func getPath() -> String {
        return path
    }
    
    func getHighestScoreDiagnostic() -> Double {
        return highestScoreDiagnostic
    }
    
    func getTotalTime() -> Int {
        return totalTime
    }
    
    func getTimeFormatted() -> String {
        return String(format: "%d:%02d", totalTime / 60, totalTime % 60)
    }
    
    func getHighestScoreTest() -> Double {
        return highestScoreChallenge
    }
    
    mutating func updateHighestScoreDiagnostic(_ score: Double) {
        highestScoreDiagnostic = max(score, highestScoreDiagnostic)
    }
    
    mutating func updateHighestScoreChallenge(_ score: Double) {
        highestScoreChallenge = max(score, highestScoreChallenge)
    }
    
    mutating func addTotalTime(_ time: Int) {
        totalTime += time
    }
}

struct ChapterInfo: Codable {
    
    var name: String = ""
    var adjustedName: String = ""
    var path: String = ""
    var highestScore: Double = 0.0
    var totalTime: Int = 0
    var misconceptions: [Misconception] = []
    
    func getName() -> String {
        return name
    }
    
    func getAdjustedName() -> String {
        return adjustedName
    }
    
    func getHighestScore() -> Double {
        return highestScore
    }
    
    func getTotalTime() -> Int {
        return totalTime
    }
    
    func getTimeFormatted() -> String {
        return String(format: "%d:%02d", totalTime / 60, totalTime % 60)
    }
    
    func getMisconceptionArray() -> [Misconception] {
        return misconceptions
    }
    
    mutating func updateHighestScore(_ score: Double) {
        highestScore = max(score, highestScore)
    }
    
    mutating func addTotalTime(_ time: Int) {
        totalTime += time
    }
}

struct TestProgress: Codable {
    var answerSelectionArray: [Int] = []
    var answersElimedArray: [[Bool]] = []
    
    func isClearSave() -> Bool {
        return answerSelectionArray.count == 0 && answersElimedArray.count == 0
    }
    
    mutating func clearSave() {
        answerSelectionArray = []
        answersElimedArray = []
    }
}

struct InfoList: Codable {
    
    var chapterInfoArray: [[ChapterInfo]]
    var unitInfoArray: [UnitInfo]
    var testProgressArray: [TestProgress]
    
    
    init() {
        chapterInfoArray = []
        unitInfoArray = []
        testProgressArray = []
        createInfo()
    }

    mutating func createInfo() {
        let digits: Set<Character> = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        for unit in loadFolderContents(AppGlobals.basePath) {
            // insert a colon when appropriate
            // quick solution for now, fix for units/chapters > 10!
            var adjUnitName = unit
            if unit.count > 4 && unit.contains(where: digits.contains) {
                let idx = adjUnitName.index(adjUnitName.startIndex, offsetBy: 6)
                adjUnitName.insert(":", at: idx)
                adjUnitName = adjUnitName.replacingOccurrences(of: "_", with: "\'")
            }
            
            unitInfoArray.append(UnitInfo(name: unit, adjustedName: adjUnitName, path: AppGlobals.basePath))
            var unitChapters: [ChapterInfo] = []
            let tempPath = AppGlobals.basePath + "/\(unit)"
            for chapter in loadFolderContents(tempPath) {
                var adjChName = chapter
                if chapter.count > 4 {
                    let idx = adjChName.index(adjChName.startIndex, offsetBy: 3)
                    adjChName.insert(contentsOf: " -", at: idx)
                    adjChName = adjChName.replacingOccurrences(of: "_", with: "\'")
                }
                let tempPath2 = tempPath + "/\(chapter)/IP"
                let files: [String] = loadFolderContents(tempPath2, onlyFolders: false)
                let miscFile: String = files.first { $0.contains("Misconceptions") }!
                let miscList = unpackMisconceptions(fileName: miscFile, subdirectory: tempPath2)
                unitChapters.append(ChapterInfo(name: chapter, adjustedName: adjChName, path: tempPath, misconceptions: miscList))
            }
            chapterInfoArray.append(unitChapters)
            
            // create test progress too
            testProgressArray.append(TestProgress())
        }
        
        // since Math Misconceptions has no folders the above code just adds an empty array for the math misconception chapters, so we handle them individuallly down here
        // just hardcoding it for now since I think it's unlikely we'll get another weirdly formatted unit like this
        var mathChapters: [ChapterInfo] = []
        let mathPath = AppGlobals.basePath + "/Math Misconceptions"
        let mathChaptersAsMisconceptions = unpackMisconceptions(fileName: "math_error_codes", subdirectory: mathPath)
        for mathChapter in mathChaptersAsMisconceptions {
            mathChapters.append(ChapterInfo(name: mathChapter.code, adjustedName: mathChapter.misconception, path: mathPath, misconceptions: []))
        }
        chapterInfoArray[0].append(contentsOf: mathChapters)
    }
    
    static func save(_ info: InfoList) {
        if let data = try? JSONEncoder().encode(info) {
            UserDefaults.standard.setValue(data, forKey: "info")
        }
    }
    
    static func load() -> InfoList? {
        if let data = UserDefaults.standard.data(forKey: "info") {
            return try? JSONDecoder().decode(InfoList.self, from: data)
        }
        return nil
    }
    
    func getChArray() -> [[ChapterInfo]] {
        return chapterInfoArray
    }
    
    func getUnitArray() -> [UnitInfo] {
        return unitInfoArray
    }
    
    func getCompletionArrayOfUnits() -> [String] {
        var facList: [String] = []
        for chapters in chapterInfoArray {
            facList.append(chapters.isEmpty ? "0%" : "\(Int(chapters.map{$0.highestScore}.reduce(0, +) / Double(chapters.count) * 100))%")
        }
        return facList
    }
    
    mutating func tallyMisconception(code: String, unitIndex: Int, chapterIndex: Int) {
        let misconceptions = chapterInfoArray[unitIndex][chapterIndex].misconceptions

        if let index = misconceptions.firstIndex(where: { $0.code == code }) {
            chapterInfoArray[unitIndex][chapterIndex].misconceptions[index].freq += 1
        }
    }
    
    func getMostCommonMisconceptions(unit: Int, chapter: Int) -> [String] {
        var miscList: [Misconception] = []
        if chapter == -1 {
            for chapter in chapterInfoArray[unit] {
                miscList.append(contentsOf: chapter.misconceptions.filter {$0.freq != 0})
            }
        }
        else {
            miscList.append(contentsOf: chapterInfoArray[unit][chapter].misconceptions.filter {$0.freq != 0})
        }
        miscList.sort {$0.freq > $1.freq}
        return Array(miscList.map {$0.misconception}.prefix(chapter == -1 ? 3 : 5))
    }
}

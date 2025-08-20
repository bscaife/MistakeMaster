//
//  QuestionUnpacker.swift
//  MistakeMaster
//
//  Created by Ben Scaife on 6/3/25 for MistakeMaster
//

import Foundation
import SwiftCSV

struct Question: Hashable {
    var question: String = ""
    var answers: [String] = ["", "", "", ""]
    var codes: [String] = ["", "", "", ""]
    var correctAnswer: Int = 0
    var explanation: String = ""
    
    init() {
        question = ""
        answers = Array(repeating: "", count: 4)
        codes = Array(repeating: "", count: 4)
        correctAnswer = 0
        explanation = ""
    }
    
    init(CSVData: [String], isDiagnosticType: Bool = true) {
        question = CSVData[0]
        if isDiagnosticType {
            answers = stride(from: 2, through: CSVData.count - 1, by: 3).map {
                CSVData[$0]
            }
            codes = stride(from: 4, through: CSVData.count - 1, by: 3).map {
                CSVData[$0]
            }
            correctAnswer = answerLetterToIndex(CSVData[1])
            explanation = CSVData[14]
        }
        else {
            answers = Array(CSVData[1...4])
            codes = Array(repeating: "", count: 4)
            correctAnswer = answerLetterToIndex(CSVData[5])
            explanation = CSVData[6]
        }
    }
}

struct WrongAnswerBreakdown: Identifiable, Hashable {
    var question: Question
    var answer: Int
    var id: Int
    
    func getQuestion() -> Question {
        return question
    }
    func getAnswer() -> Int {
        return answer
    }
    func getId() -> Int {
        return id
    }
}

struct Misconception: Codable, Hashable {
    var code: String = ""
    var misconception: String = ""
    var explanation: String = ""
    var freq: Int = 0
    
    init(CSVData: [String]) {
        code = CSVData[0]
        misconception = CSVData[1]
        explanation = CSVData[2...].joined(separator: ",").replacingOccurrences(of: "\"", with: "")
    }
    
    init() {
        
    }
}

func answerLetterToIndex(_ letter: String) -> Int {
    let key: [String: Int] = ["A": 0, "B": 1, "C": 2, "D": 3]
    return key[letter] ?? 0
}

func CSVtoStringArray(fileName: String, subdirectory: String) -> [[String]] {
    let cleanName = fileName.replacingOccurrences(of: ".csv", with: "")
    
    if let fileURL = Bundle.main.url(forResource: cleanName, withExtension: "csv", subdirectory: subdirectory) {
        do {
            let csv = try CSV<Named>(url: fileURL)
            let data: [[String]] = csv.rows.map { row in
                csv.header.map {row[$0] ?? ""}
            }
            return data
        }
        catch {
            print("CSV parsing error with \(subdirectory)/\(cleanName).csv")
        }
    }
    return []
}

func unpackQuestions(fileName: String, subdirectory: String, loadDiagnosticType: Bool = true) -> [Question] {
    
    var questionSet = [Question]()
    
    let rows = CSVtoStringArray(fileName: fileName, subdirectory: subdirectory)
    
    for row in rows {
        let questionObject = Question.init(CSVData: row, isDiagnosticType: loadDiagnosticType)
        questionSet.append(questionObject)
    }
    
    return questionSet
    
}

func unpackMisconceptions(fileName: String, subdirectory: String) -> [Misconception] {

    var misconceptionSet = [Misconception]()
    
    let rows = CSVtoStringArray(fileName: fileName, subdirectory: subdirectory)
    
    for row in rows {
        let misconceptionObject = Misconception.init(CSVData: row)
        misconceptionSet.append(misconceptionObject)
    }
    
    return misconceptionSet
    
}

func loadFolderContents(_ path: String, onlyFolders: Bool = true) -> [String] {
    guard let subjectsURL = Bundle.main.url(forResource: path, withExtension: nil) else {
            return []
    }
    do {
        let contents = try FileManager.default.contentsOfDirectory(at: subjectsURL, includingPropertiesForKeys: [.isDirectoryKey])
        
        let filteredContents = contents.filter { url in
            if onlyFolders {
                return (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true
            } else {
                return true
            }
        }
        .sorted(by: { $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending })
        
        return filteredContents.map { $0.lastPathComponent }
    } catch {
        print("Error reading Subjects folder: \(error)")
        return []
    }
}

func makeAreasDict(fileNameList: [String], path: String) -> [String: [Question]] {
    var qAreas: [[Question]] = []
    for file in fileNameList {
        qAreas.append(unpackQuestions(fileName: file, subdirectory: path, loadDiagnosticType: false))
    }
    let filteredNameList = fileNameList.map{String($0.dropLast(4))}
    return Dictionary(uniqueKeysWithValues: zip(filteredNameList, qAreas))
}

func makeMisconceptionsDict(path: String) -> [String: Misconception] {
    let files: [String] = loadFolderContents(path, onlyFolders: false)
    let misconceptionsFile: String = files.first { $0.contains("Misconceptions") }!
    let misconceptions: [Misconception] = unpackMisconceptions(fileName: misconceptionsFile, subdirectory: path)
    let errorCodeList = misconceptions.map {$0.code}
    return Dictionary(uniqueKeysWithValues: zip(errorCodeList, misconceptions))
}

//func makeMisconceptionsDict(path: String) -> [String: Misconception] {
//    let files: [String] = loadFolderContents(path, onlyFolders: false)
//    let misconceptionsFile: String = files.first { $0.contains("Misconceptions") }! // dude
//    let errorCodeList: [String] = files.dropLast()
//    let misconceptions: [Misconception] = unpackMisconceptions(fileName: misconceptionsFile, subdirectory: path)
//    let filteredNameList = errorCodeList.map{String($0.dropLast(4))}
//    return Dictionary(uniqueKeysWithValues: zip(filteredNameList, misconceptions))
//}

//
//  Summary.swift
//  MistakeMaster
//
//  Created by Ben Scaife on 7/26/25 for MistakeMaster.
//

import Foundation
import SwiftUI

struct AppGlobals {
    static var BGColor1 = Color(hue: 0.27, saturation: 0.45, brightness: 1)
    static var BGColor2 = Color(hue: 0.29, saturation: 0.33, brightness: 1)
    static var buttonCol1 = Color(hue: 0.4, saturation: 0.8, brightness: 1.0)
    static var buttonCol2 = Color(hue: 0.4, saturation: 0.8, brightness: 0.7)
    static var buttonColElim1 = Color(hue: 0.4, saturation: 0, brightness: 1.0 * 0.7)
    static var buttonColElim2 = Color(hue: 0.4, saturation: 0, brightness: 0.7 * 0.7)
    static var buttonColRed1 = Color(hue: 0, saturation: 0.6, brightness: 1.0)
    static var buttonColRed2 = Color(hue: 0, saturation: 0.6, brightness: 0.7)
    static var textColor = Color(hue: 0, saturation: 0, brightness: 0)
    static var buttonOutlineColor = Color(hue: 0.45, saturation: 0.6, brightness: 0.35)
    static var buttonOutlineColorElim = Color(hue: 0.45, saturation: 0, brightness: 0.35 * 0.7)
    static var buttonOutlineColorWrong = Color(hue: 0, saturation: 0.8, brightness: 0.33)
    
    static let waveOffset = 0.5
    static let fps = 60.0
    
    // change this variable to false to enable the lite version, and true to enable the full version
    static let isFullVersion = false
    
    @AppStorage("theme") static var theme: String = "classic"
    @AppStorage("animSpeed") static var animSpeed: String = "Normal"
    @AppStorage("overrideDiagnostic") static var overrideDiagnostic = false
    @AppStorage("buttonWobble") static var buttonWobble = true
    @AppStorage("firstLoading") static var firstLoading = true
    @AppStorage("isMuted") static var isMuted = false
    
    static let basePath = "Subjects/AP Physics"
    
    static func setThemeClassic() {
        BGColor1 = Color(red: 0.676, green: 1, blue: 0.609)
        BGColor2 = Color(red: 0.835, green: 1, blue: 0.749)
        buttonCol1 = Color(red: 0.239, green: 1, blue: 0.576)
        buttonCol2 = Color(red: 0.059, green: 0.745, blue: 0.443)
        buttonColElim1 = Color(hue: 0.4, saturation: 0, brightness: 1.0 * 0.7)
        buttonColElim2 = Color(hue: 0.4, saturation: 0, brightness: 0.7 * 0.7)
        buttonColRed1 = Color(hue: 0, saturation: 0.55, brightness: 1.0)
        buttonColRed2 = Color(hue: 0.95, saturation: 0.65, brightness: 0.7)
        textColor = Color(hue: 0, saturation: 0, brightness: 0)
        buttonOutlineColor = Color(hue: 0.45, saturation: 0.6, brightness: 0.35)
        buttonOutlineColorElim = Color(hue: 0.45, saturation: 0, brightness: 0.35 * 0.7)
        buttonOutlineColorWrong = Color(hue: 0.9, saturation: 0.8, brightness: 0.33)
        
        UserDefaults.standard.set("classic", forKey: "theme")
    }
    
    static func setThemeLight() {
        BGColor1 = Color(red: 0.915, green: 0.934, blue: 0.973)
        BGColor2 = Color(red: 0.942, green: 0.964, blue: 0.977)
        buttonCol1 = Color(red: 0.969, green: 1, blue: 0.996)
        buttonCol2 = Color(red: 0.745, green: 0.8, blue: 0.827)
        buttonColElim1 = Color(hue: 0.59, saturation: 0.06, brightness: 0.85)
        buttonColElim2 = Color(hue: 0.62, saturation: 0.09, brightness: 0.77)
        buttonColRed1 = Color(hue: 0, saturation: 0.47, brightness: 1.0)
        buttonColRed2 = Color(hue: 0.95, saturation: 0.47, brightness: 0.7)
        textColor = Color(hue: 0, saturation: 0, brightness: 0)
        buttonOutlineColor = Color(hue: 0.55, saturation: 0.1, brightness: 0.35)
        buttonOutlineColorElim = Color(hue: 0.45, saturation: 0, brightness: 0.35 * 0.7)
        buttonOutlineColorWrong = Color(hue: 0.9, saturation: 0.8, brightness: 0.33)
        
        UserDefaults.standard.set("light", forKey: "theme")
    }
    
    static func setThemeDark() {
        BGColor1 = Color(red: 0.063, green: 0.071, blue: 0.094)
        BGColor2 = Color(red: 0.078, green: 0.098, blue: 0.129)
        buttonCol1 = Color(red: 0.094, green: 0.106, blue: 0.118)
        buttonCol2 = Color(red: 0.012, green: 0.016, blue: 0.016)
        buttonColElim1 = Color(hue: 0.57, saturation: 0.09, brightness: 0.04)
        buttonColElim2 = Color(hue: 0.52, saturation: 0.14, brightness: 0.01)
        buttonColRed1 = Color(hue: 0, saturation: 0.6, brightness: 0.65)
        buttonColRed2 = Color(hue: 0.95, saturation: 0.65, brightness: 0.50)
        textColor = Color(hue: 0, saturation: 0, brightness: 1)
        buttonOutlineColor = Color(hue: 0.58, saturation: 0.2, brightness: 0.25)
        buttonOutlineColorElim = Color(hue: 0.65, saturation: 0.05, brightness: 0.15)
        buttonOutlineColorWrong = Color(hue: 0.9, saturation: 0.8, brightness: 0.33)
        
        UserDefaults.standard.set("dark", forKey: "theme")
    }
    
    static func setThemeSpace() {
        BGColor1 = Color(red: 0.016, green: 0.024, blue: 0.114)
        BGColor2 = Color(red: 0.043, green: 0.047, blue: 0.157)
        buttonCol1 = Color(red: 0.128, green: 0.073, blue: 0.237) 
        buttonCol2 = Color(red: 0.071, green: 0.024, blue: 0.208)
        buttonColElim1 = Color(hue: 0.64, saturation: 0.4, brightness: 0.12)
        buttonColElim2 = Color(hue: 0.59, saturation: 0.35, brightness: 0.08)
        buttonColRed1 = Color(hue: 0.96, saturation: 0.55, brightness: 0.57)
        buttonColRed2 = Color(hue: 0.9, saturation: 0.65, brightness: 0.43)
        textColor = Color(hue: 0.65, saturation: 0.2, brightness: 1)
        buttonOutlineColor = Color(red: 0.264, green: 0.141, blue: 0.359)
        buttonOutlineColorElim = Color(hue: 0.65, saturation: 0.05, brightness: 0.25)
        buttonOutlineColorWrong = Color(hue: 0.85, saturation: 0.8, brightness: 0.33)
        
        UserDefaults.standard.set("space", forKey: "theme")
    }
    
    static func isLighterTheme() -> Bool {
        return theme == "classic" || theme == "light"
    }
    
    static func getAnimSpeed() -> CGFloat {
        return animSpeed == "Normal" ? 1 : (animSpeed == "Fast" ? 0.5 : 0)
    }
}
//
//static func setThemeLight() {
//    BGColor1 = Color(hue: 0.55, saturation: 0.09, brightness: 0.96)
//    BGColor2 = Color(hue: 0.51, saturation: 0.07, brightness: 0.96)
//    buttonCol1 = Color(hue: 0.6, saturation: 0.03, brightness: 0.99)
//    buttonCol2 = Color(hue: 0.55, saturation: 0.03, brightness: 0.91)
//    buttonColElim1 = Color(hue: 0.4, saturation: 0, brightness: 0.4 * 0.7)
//    buttonColElim2 = Color(hue: 0.4, saturation: 0, brightness: 0.5 * 0.7)
//    buttonColRed1 = Color(hue: 0, saturation: 0.6, brightness: 1.0)
//    buttonColRed2 = Color(hue: 0, saturation: 0.6, brightness: 0.7)
//    textColor = Color(hue: 0, saturation: 0, brightness: 0)
//    buttonOutlineColor = Color(hue: 0.55, saturation: 0.1, brightness: 0.35)
//    
//    UserDefaults.standard.set("light", forKey: "theme")
//}
//static func setThemeDark() {
//    BGColor1 = Color(hue: 0.6, saturation: 0.15, brightness: 0.2)
//    BGColor2 = Color(hue: 0.55, saturation: 0.1, brightness: 0.2)
//    buttonCol1 = Color(hue: 0.7, saturation: 0.17, brightness: 0.35)
//    buttonCol2 = Color(hue: 0.65, saturation: 0.19, brightness: 0.3)
//    buttonColElim1 = Color(hue: 0.4, saturation: 0, brightness: 0.4 * 0.7)
//    buttonColElim2 = Color(hue: 0.4, saturation: 0, brightness: 0.5 * 0.7)
//    buttonColRed1 = Color(hue: 0, saturation: 0.6, brightness: 1.0)
//    buttonColRed2 = Color(hue: 0, saturation: 0.6, brightness: 0.7)
//    textColor = Color(hue: 0, saturation: 0, brightness: 1)
//    buttonOutlineColor = Color(hue: 0.55, saturation: 0.4, brightness: 0.65)
//    
//    UserDefaults.standard.set("dark", forKey: "theme")
//}
//
//static func setThemeSpace() {
//    BGColor1 = Color(hue: 0.6, saturation: 0.25, brightness: 0.15)
//    BGColor2 = Color(hue: 0.57, saturation: 0.2, brightness: 0.15)
//    buttonCol1 = Color(hue: 0.7, saturation: 0.6, brightness: 0.4)
//    buttonCol2 = Color(hue: 0.65, saturation: 0.6, brightness: 0.5)
//    buttonColElim1 = Color(hue: 0.4, saturation: 0, brightness: 0.4 * 0.7)
//    buttonColElim2 = Color(hue: 0.4, saturation: 0, brightness: 0.5 * 0.7)
//    buttonColRed1 = Color(hue: 0, saturation: 0.6, brightness: 1.0)
//    buttonColRed2 = Color(hue: 0, saturation: 0.6, brightness: 0.7)
//    textColor = Color(hue: 0.65, saturation: 0.2, brightness: 1)
//    buttonOutlineColor = Color(hue: 0.67, saturation: 0.4, brightness: 0.65)
//    
//    UserDefaults.standard.set("space", forKey: "theme")
//}
//}
//static func setThemeClassic() {
//    BGColor1 = Color(hue: 0.27, saturation: 0.45, brightness: 1)
//    BGColor2 = Color(hue: 0.29, saturation: 0.33, brightness: 1)
//    buttonCol1 = Color(hue: 0.4, saturation: 0.8, brightness: 1.0)
//    buttonCol2 = Color(hue: 0.4, saturation: 0.8, brightness: 0.7)
//    buttonColElim1 = Color(hue: 0.4, saturation: 0, brightness: 1.0 * 0.7)
//    buttonColElim2 = Color(hue: 0.4, saturation: 0, brightness: 0.7 * 0.7)
//    buttonColRed1 = Color(hue: 0, saturation: 0.6, brightness: 1.0)
//    buttonColRed2 = Color(hue: 0, saturation: 0.6, brightness: 0.7)
//    textColor = Color(hue: 0, saturation: 0, brightness: 0)
//    buttonOutlineColor = Color(hue: 0.45, saturation: 0.6, brightness: 0.35)
//    
//    UserDefaults.standard.set("classic", forKey: "theme")
//}

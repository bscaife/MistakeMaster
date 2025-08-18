//
//  SettingsView.swift
//  MistakeMaster
//
//  Created by 3 Kings on 8/14/25.
//

import SwiftUI

struct SettingsView: View {
    @Binding var viewPath: NavigationPath
    @EnvironmentObject var globalTimer: GlobalTimer
    @State var resetWarning = false
    @Binding var info: InfoList
    
    var nullFunc: () -> Void = {}
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            MainMenuGradientBackground(col1: AppGlobals.BGColor1, col2: AppGlobals.BGColor2)
            VStack {
                Button {
                    dismiss()
                }
                label: {
                    Text("Back")
                        .labelMod(100, 50, globalTimer.time - AppGlobals.waveOffset, textPadding: 12)
                }
                .offset(x: -122)
                .buttonStyle(DefaultButtonStyle())
                VStack {
                    Text("Settings")
                        .bold()
                        .font(.custom("futura", size: 70))
                        .padding(.vertical, -10)
                    Separator(col1: AppGlobals.buttonCol2, width: 310)
                        .padding(15)
                    HStack {
                        Text("Theme:")
                        Spacer()
                        Button {
                            AppGlobals.setThemeClassic()
                        }
                        label: {
                            Text("Classic")
                                .smallButtonMod(AppGlobals.buttonCol2)
                        }
                        .buttonStyle(DefaultButtonStyle())
                        Button {
                            AppGlobals.setThemeLight()
                        }
                        label: {
                            Text("Light")
                                .smallButtonMod(AppGlobals.buttonCol2)
                        }
                        .buttonStyle(DefaultButtonStyle())
                    }
                    .frame(width: 310)
                    .padding(-5)
                    HStack {
                        Spacer()
                        Button {
                            SoundManager.toggleMuted()
                            UserDefaults.standard.set(AppGlobals.animSpeed, forKey: "animSpeed")
                        } label: {
                            Image(systemName: AppGlobals.isMuted ? "speaker.slash.fill" : "speaker.wave.3.fill")
                                .resizable()
                                .foregroundStyle(AppGlobals.textColor)
                            
                        }
                        .frame(width: 40, height: 30)
                        .buttonStyle(DefaultButtonStyle())
                        Spacer()
                        Spacer()
                        Button {
                            AppGlobals.setThemeSpace()
                        }
                        label: {
                            Text("Space")
                                .smallButtonMod(AppGlobals.buttonCol2)
                        }
                        .buttonStyle(DefaultButtonStyle())
                        Button {
                            AppGlobals.setThemeDark()
                        }
                        label: {
                            Text("Dark")
                                .smallButtonMod(AppGlobals.buttonCol2)
                        }
                        .buttonStyle(DefaultButtonStyle())
                    }
                    .frame(width: 310)
                    HStack {
                        Text("Anim. speed:")
                        Spacer()
                        Button {
                            if AppGlobals.animSpeed == "Normal" {
                                AppGlobals.animSpeed = "Fast"
                            }
                            else if AppGlobals.animSpeed == "Fast" {
                                AppGlobals.animSpeed = "None"
                            }
                            else {
                                AppGlobals.animSpeed = "Normal"
                            }
                            UserDefaults.standard.set(AppGlobals.animSpeed, forKey: "animSpeed")
                        }
                        label: {
                            Text(AppGlobals.animSpeed)
                                .smallButtonMod(AppGlobals.buttonCol2)
                        }
                        .buttonStyle(DefaultButtonStyle())
                    }
                    .frame(width: 310)
                    HStack {
                        Text("Override All Diagnostics:")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Button {
                            AppGlobals.overrideDiagnostic.toggle()
                            UserDefaults.standard.set(AppGlobals.overrideDiagnostic, forKey: "overrideDiagnostic")
                        }
                        label: {
                            Text(AppGlobals.overrideDiagnostic ? "Enabled" : "Disabled")
                                .smallButtonMod(AppGlobals.buttonCol2)
                        }
                        .buttonStyle(DefaultButtonStyle())
                    }
                    .frame(width: 310)
                    HStack {
                        Text("Wobble:")
                        Spacer()
                        Button {
                            AppGlobals.buttonWobble.toggle()
                            UserDefaults.standard.set(AppGlobals.buttonWobble, forKey: "buttonWobble")
                        }
                        label: {
                            Text(AppGlobals.buttonWobble ? "Enabled" : "Disabled")
                                .smallButtonMod(AppGlobals.buttonCol2)
                        }
                        .buttonStyle(DefaultButtonStyle())
                    }
                    .frame(width: 310)
                    Button {
                        resetSettings()
                    }
                    label: {
                        Text("Reset to defaults")
                            .smallButtonMod(AppGlobals.buttonCol2)
                            .animation(nil, value: resetWarning)
                    }
                    .buttonStyle(DefaultButtonStyle())
                    Button {
                        if !resetWarning {
                            resetWarning = true
                        }
                        else {
                            info = InfoList()
                            InfoList.save(info)
                            
                            resetSettings()
                            
                            AppGlobals.firstLoading = true
                            UserDefaults.standard.set(AppGlobals.firstLoading, forKey: "firstLoading")
                            
                            resetWarning = false
                        }
                    }
                    label: {
                        Text(resetWarning ? "Are you sure?    " : "Reset your data")
                            .smallButtonMod(AppGlobals.buttonCol2)
                            .animation(nil, value: resetWarning)
                    }
                    .buttonStyle(DefaultButtonStyle())
                    
                }
                .labelMod(350, 650, globalTimer.time)
                .padding(40)
                Rectangle()
                    .fill(.clear)
                    .frame(height: 50)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
    }
    
    func resetSettings() {
        AppGlobals.setThemeClassic()
        
        AppGlobals.animSpeed = "Normal"
        UserDefaults.standard.set(AppGlobals.animSpeed, forKey: "animSpeed")
        
        AppGlobals.overrideDiagnostic = false
        UserDefaults.standard.set(AppGlobals.overrideDiagnostic, forKey: "overrideDiagnostic")
        
        AppGlobals.buttonWobble = true
        UserDefaults.standard.set(AppGlobals.buttonWobble, forKey: "buttonWobble")
        
        if AppGlobals.isMuted {
            SoundManager.toggleMuted()
        }
    }
}

#Preview {
    SettingsView(viewPath: .constant(NavigationPath()), info: .constant(InfoList()))
        .environmentObject(GlobalTimer())
}


//
//  ParticleView.swift
//  MistakeMaster
//
//  Created by Ben Scaife on 6/2/25 for MistakeMaster
//

import SwiftUI
import UIKit

struct ParticleView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * -0.35)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: UIScreen.main.bounds.width * 0.6, height: 1)

        let cell = CAEmitterCell()
        cell.birthRate = 1
        cell.lifetime = 50.0
        cell.velocity = 50
        cell.velocityRange = 30
        cell.emissionLongitude = .pi
        cell.spin = 0.5
        cell.spinRange = 0.4
        cell.scale = 0.6
        cell.scaleRange = 0.7
        cell.contents = UIImage(named: "rectParticleImage")?.cgImage
//        cell.color = UIColor(AppGlobals.BGColor1).cgColor
        cell.color = UIColor.white.cgColor
        
        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct MenuParticleView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        let emitter = CAEmitterLayer()
        emitter.emitterShape = .line
        emitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4)
        emitter.emitterSize = CGSize(width: UIScreen.main.bounds.height * 1.5, height: 1)
        emitter.setAffineTransform(CGAffineTransform(rotationAngle: .pi / 2))

        let cell = CAEmitterCell()
        cell.contents = UIImage(systemName: "folder.circle")?.cgImage
        cell.birthRate = 100
        cell.lifetime = 60.0
        cell.velocity = 50
        cell.velocityRange = 10
        cell.spin = 0.5
        cell.spinRange = 0.5
        cell.velocityRange = 20
        cell.emissionLongitude = 0
        cell.emissionRange = 0.4
        cell.scale = 0.1
        cell.scaleRange = 0.1
        cell.color = UIColor.white.cgColor

        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct MainMenuParticleView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        let emitter = CAEmitterLayer()
        emitter.emitterShape = .line
        emitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 1.2)
        emitter.emitterSize = CGSize(width: UIScreen.main.bounds.height * 1.5, height: 1)
        emitter.setAffineTransform(CGAffineTransform(rotationAngle: -.pi / 10))

        let cell = CAEmitterCell()
        cell.contents = UIImage(systemName: "circle.fill")?.cgImage
        cell.birthRate = 1.5
        cell.lifetime = 60.0
        cell.velocity = 70
        cell.velocityRange = 25
        cell.emissionLongitude = 0
        cell.emissionRange = 0.5
        cell.scale = 2.7
        cell.scaleRange = 13
        cell.color = UIColor.white.cgColor

        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct ProgressBarParticleView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        let emitter = CAEmitterLayer()
        emitter.emitterShape = .line
        emitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4)
        emitter.emitterSize = CGSize(width: 1, height: 1)
        emitter.setAffineTransform(CGAffineTransform(rotationAngle: .pi / 2))

        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "rectSlanted2")?.cgImage
        cell.birthRate = 0.35
        cell.lifetime = 120.0
        cell.velocity = 25
        cell.emissionLongitude = 0
        cell.scale = 0.5
        cell.color = UIColor.white.cgColor

        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

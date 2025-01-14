//
//  ViewModel.swift
//  FreeHand
//
//  Created by Kyoya Yamaguchi on 2024/11/24.
//

import PencilKit
import SwiftUI

class ViewModel: NSObject, ObservableObject {
    
    @Published var canvasView = TouchHandlablePKCanvasView()
    @Published var inkType: PKInk.InkType = .pencil
    @Published var penColor: Color = .black
    @Published var penWidth: Double = 5
    @Published var rotation: Double = 0
    @Published var position: CGPoint = .init(x: -100, y: -100)
    @Published var isEraser = false
    
    override init() {
        super.init()
        updateTool()
    }
    
    var initialDegree: Double?
    
    func updateSelectedCell(degrees: Double) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let padding: CGFloat = 45
        withAnimation {
            switch degrees {
            case 0..<22.5, 337.5..<360: //middle Trailing
                rotation = 270
                position = .init(x: screenWidth - padding, y: screenHeight / 2)
            case 22.5..<67.5: //bottomTrailing
                rotation = 315
                position = .init(x: screenWidth - padding * 3, y: screenHeight - padding * 3)
            case 67.5..<112.5: //bottomCenter
                rotation = 360
                position = .init(x: screenWidth / 2, y: screenHeight - padding)
            case 112.5..<157.5: //bottomLeading
                rotation = 45
                position = .init(x: padding * 3, y: screenHeight - padding * 3)
            case 157.5..<202.5: //middleLeading
                rotation = 90
                position = .init(x: padding, y: screenHeight / 2)
            case 202.5..<247.5: //topLeading
                rotation = 135
                position = .init(x: padding * 3, y: padding * 3)
            case 247.5..<292.5: //topCenter
                rotation = 180
                position = .init(x: screenWidth / 2, y: padding)
            case 292.5..<337.5: //topTrailing
                rotation = 225
                position = .init(x: screenWidth - padding * 3, y: padding * 3)
            default:
                break
            }
        }
    }
    
    func updateTool() {
        canvasView.tool = PKInkingTool(inkType, color: UIColor(penColor), width: penWidth)
    }
    
    func toggleTool() {
        if isEraser {
            updateTool()
        } else {
            canvasView.tool = PKEraserTool(.bitmap, width: penWidth)
        }
        isEraser.toggle()
    }
}

extension ViewModel: PKCanvasViewDelegate, UIPencilInteractionDelegate {
    func pencilInteraction(_ interaction: UIPencilInteraction,
                           didReceiveSqueeze squeeze: UIPencilInteraction.Squeeze) {
        if UIPencilInteraction.preferredSqueezeAction == .showContextualPalette &&
            squeeze.phase == .began, let hoverPose = squeeze.hoverPose {
            let azimuthAngle = hoverPose.azimuthAngle * 180 / .pi
            let zOffset = hoverPose.zOffset
            print(azimuthAngle, zOffset)
        }
    }
}

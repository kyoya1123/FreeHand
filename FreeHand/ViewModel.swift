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
    @Published var inkType: PKInk.InkType = .pen
    @Published var penColor: Color = .black
    @Published var penWidth: Double = 2
    @Published var rotation: Double = 0
    @Published var position: CGPoint = .init(x: -100, y: -100)
    @Published var isLocked: Bool = false
    
    func updateSelectedCell(degrees: Double) {
        guard !isLocked else { return }
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let padding: CGFloat = 40
        withAnimation {
            switch degrees {
            case 0..<45, 315..<360: //middle trailing
                rotation = 90
                position = .init(x: screenWidth - padding, y: screenHeight / 2)
            case 45..<135: //bottom center
                rotation = 0
                position = .init(x: screenWidth / 2, y: screenHeight - padding)
            case 135..<225: //middle leading
                rotation = 90
                position = .init(x: padding, y: screenHeight / 2)
            case 225..<315: //top center
                rotation = 0
                position = .init(x: screenWidth / 2, y: padding)
            default:
                break
            }
        }
    }
    
    func updateTool() {
        canvasView.tool = PKInkingTool(.pen, color: UIColor(penColor), width: penWidth)
    }
    
    func toggleTool() {
        if canvasView.tool is PKInkingTool {
            canvasView.tool = PKEraserTool(.bitmap, width: 10)
        } else {
            canvasView.tool = PKInkingTool(.pen, color: .black, width: 2)
        }
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

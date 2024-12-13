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
    @Published var selectedCell: (row: Int, column: Int)?
    
    let rows = 3
    let columns = 3
    
    func isSelected(row: Int, column: Int) -> Bool {
        if let selectedCell, selectedCell.row == row, selectedCell.column == column {
            return true
        } else {
            return false
        }
    }
    
    func isOuterCell(row: Int, column: Int) -> Bool {
        row == 0 || row == rows - 1 || column == 0 || column == columns - 1
    }
    
    func updateSelectedCell(degrees: Double) {
        DispatchQueue.main.async {
            switch degrees {
            case 0..<22.5, 337.5..<360:
                self.selectedCell = (row: 1, column: 2)
            case 22.5..<67.5:
                self.selectedCell = (row: 2, column: 2)
            case 67.5..<112.5:
                self.selectedCell = (row: 2, column: 1)
            case 112.5..<157.5:
                self.selectedCell = (row: 2, column: 0)
            case 157.5..<202.5:
                self.selectedCell = (row: 1, column: 0)
            case 202.5..<247.5:
                self.selectedCell = (row: 0, column: 0)
            case 247.5..<292.5:
                self.selectedCell = (row: 0, column: 1)
            case 292.5..<337.5:
                self.selectedCell = (row: 0, column: 2)
            default:
                self.selectedCell = nil
            }
        }
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

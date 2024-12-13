//
//  ContentView.swift
//  FreeHand
//
//  Created by Kyoya Yamaguchi on 2024/11/24.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel = .init()
    
    var body: some View {
        ZStack {
            CanvasView(viewModel: viewModel)
            
            let gridSize = 3
            let cellSize: CGFloat = 50
            let totalHorizontalSpacing = UIScreen.main.bounds.width - 32 - (CGFloat(gridSize) * cellSize)
            let horizontalSpacing = totalHorizontalSpacing / CGFloat(gridSize - 1)
            let totalVerticalSpacing = UIScreen.main.bounds.height - 32 - (CGFloat(gridSize) * cellSize)
            let verticalSpacing = totalVerticalSpacing / CGFloat(gridSize - 1)
            
            
            Grid(horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing) {
                ForEach(0..<gridSize, id: \.self) { row in
                    GridRow {
                        ForEach(0..<gridSize, id: \.self) { column in
                            if viewModel.isOuterCell(row: row, column: column) {
                                Button {
                                    
                                } label: {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 50, height: 50)
                                }
                                .opacity(viewModel.isSelected(row: row, column: column) ? 1 : 0)
                            } else {
                                Color.clear
                                    .frame(width: 50, height: 50)
                            }
                        }
                    }
                }
            }
        }
        .onPencilSqueeze { phase in
            if case let .active(value) = phase, let hoverPose = value.hoverPose {
                viewModel.updateSelectedCell(degrees: hoverPose.azimuth.degrees + 180)      
            } else if case let .ended(value) = phase {
                
            }
        }
        .statusBar(hidden: true)
        .persistentSystemOverlays(.hidden)
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}

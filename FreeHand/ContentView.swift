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
                                VStack {
//                                    let sliderHeight: CGFloat = 100
//                                    Slider(value: $viewModel.widthValue, in: 2...10, label: {
//                                        Text("")
//                                    }, minimumValueLabel: {
//                                        Image(systemName: "scribble")
//                                    }, maximumValueLabel: {
//                                        Image(systemName: "scribble.variable")
//                                    })
//                                    .labelsHidden()
//                                    .rotationEffect(.degrees(-90.0))
//                                    .frame(width: sliderHeight)
//                                    .offset(x: -100, y: sliderHeight)
                                    Button {
                                        viewModel.canvasView.tool = PKInkingTool(ink: .init(.pen, color: .blue), width: 2)
                                    } label: {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 50, height: 50)
                                    }
                                    Button {
                                        viewModel.canvasView.tool = PKInkingTool(ink: .init(.pen, color: .red), width: 2)
                                    } label: {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 50, height: 50)
                                    }
                                    Button {
                                        viewModel.canvasView.tool = PKInkingTool(ink: .init(.pen, color: .green), width: 2)
                                    } label: {
                                        Circle()
                                            .fill(Color.green)
                                            .frame(width: 50, height: 50)
                                    }
                                }
                                .rotationEffect(.degrees(rotation(row: row, column: column)))
                                .offset(y: offset(row: row, column: column))
                                .opacity(viewModel.isSelected(row: row, column: column) ? 1 : 0)
//                                Button {
//                                    
//                                } label: {
//                                    Circle()
//                                        .fill(Color.blue)
//                                        .frame(width: 50, height: 50)
//                                }
//                                  .opacity(viewModel.isSelected(row: row, column: column) ? 1 : 0)
                                
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
    
    func rotation(row: Int, column: Int) -> Double {
        switch (row, column) {
        case (0, 1):
            return 90
        case (1, 0):
            return 0
        case (1, 2):
            return 0
        case (2, 1):
            return -90
        default:
            return 0
        }
    }
    
    func offset(row: Int, column: Int) -> Double {
        switch (row, column) {
        case (0, 1):
            return 130
        case (1, 0):
            return 0
        case (1, 2):
            return 0
        case (2, 1):
            return -100
        default:
            return 0
        }
    }
    
}

#Preview {
    ContentView()
}

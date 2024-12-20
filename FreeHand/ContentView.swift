//
//  ContentView.swift
//  FreeHand
//
//  Created by Kyoya Yamaguchi on 2024/11/24.
//

import CompactSlider
import PencilKit
import SwiftUI

/*
 TODO:
 - 描き始めだけ移動する
 - 角のUI欲しい
 -
 
 */

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel = .init()
    
    var body: some View {
        ZStack {
            CanvasView(viewModel: viewModel)
            HStack {
                CompactSlider(value: $viewModel.penWidth, in: 1...50, scaleVisibility: .hidden, minHeight: 50, enableDragGestureDelayForiOS: false) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 10))
                    Spacer()
                    Image(systemName: "circle.fill")
                        .font(.system(size: 20))
                }
                .frame(width: 200)
                .onChange(of: viewModel.penWidth) {
                    viewModel.updateTool()
                }
                ColorPicker(selection: $viewModel.penColor, label: { Text("") })
                    .labelsHidden()
                    .onChange(of: viewModel.penColor) {
                        viewModel.updateTool()
                    }
            }
            .rotationEffect(.degrees(viewModel.rotation))
            .position(x: viewModel.position.x, y: viewModel.position.y)
        }
        .onPencilSqueeze { phase in
            if case let .active(value) = phase/*, let hoverPose = value.hoverPose*/ {
                viewModel.isLocked.toggle()
            }
//            else if case let .ended(value) = phase {
//            }
        }
        .statusBar(hidden: true)
        .persistentSystemOverlays(.hidden)
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}

//
//  FieldView.swift
//  checkers
//
//  Created by Damian Wiśniewski on 15/01/2023.
//

import SwiftUI

struct FieldView: View {
    let col: Int
    let row: Int
    @ObservedObject var board: GameBoard
    
    var body: some View {
        Rectangle()
            .fill(calculateColor())
            .frame(width: fieldSize, height: fieldSize)
            .overlay {
                Text("\(row)/\(col)")
                    .foregroundColor(.red)
                GeometryReader { proxy -> Color in
                    board.update(frame: proxy.frame(in: .global), for: CGPoint(x: col, y: row))
                    return Color.clear
                }
            }
    }
    
    func calculateColor() -> Color {
        return (col - row) % 2 == 0 ? .white : .black
    }
}

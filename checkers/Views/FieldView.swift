//
//  FieldView.swift
//  checkers
//
//  Created by Damian Wiśniewski on 15/01/2023.
//

import SwiftUI

struct FieldView: View {
    @State var color: Color = .white
    var col: Int
    var row: Int
    var piece: Bool = false
    var pieceColor: Color = .red
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(calculateColor())
                .frame(width: fieldSize, height: fieldSize)
            
            if piece {
                PieceView(color: pieceColor)
            }
        }
    }
    
    func calculateColor() -> Color {
        return (col - row) % 2 == 0 ? .white : .black
    }
}

struct FieldView_Previews: PreviewProvider {
    static var previews: some View {
        FieldView(color: .white, col: 0, row: 0)
        FieldView(color: .white, col: 0, row: 0, piece: true, pieceColor: .red)
    }
}

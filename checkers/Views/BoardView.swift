//
//  BoardView.swift
//  checkers
//
//  Created by Damian Wiśniewski on 15/01/2023.
//

import SwiftUI

struct BoardView: View {
    var body: some View {
        Grid(horizontalSpacing:1, verticalSpacing: 1) {
            ForEach(0..<boardSize) { row in
                GridRow {
                    ForEach(0..<boardSize) { col in
                        if (col - row) % 2 != 0 && row != 3 && row != 4 {
                            FieldView(col: col, row: row, piece: true, pieceColor: row >= 5 ? .white : .red)
                        } else {
                            FieldView(col: col, row: row)
                        }
                    }
                }
            }
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}

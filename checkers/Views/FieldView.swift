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
    
    var body: some View {
        Rectangle()
            .fill(calculateColor())
            .frame(width: fieldSize, height: fieldSize)
    }
    
    func calculateColor() -> Color {
        return (col - row) % 2 == 0 ? .white : .black
    }
}

struct FieldView_Previews: PreviewProvider {
    static var previews: some View {
        FieldView(col: 0, row: 0)
    }
}

//
//  PieceView.swift
//  checkers
//
//  Created by Damian Wiśniewski on 15/01/2023.
//

import SwiftUI

struct PieceView: View {
    var color: Color = .red
    
    var body: some View {
        Circle()
            .foregroundStyle(
                    color.gradient.shadow(
                        .inner(color: .black.opacity(0.8), radius: 2, x: -2, y: -2)
                    )
                )
            .frame(width: pieceSize, height: pieceSize)
            .shadow(radius: 5, x: 5, y: 5)
    }
}

struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        PieceView()
            .frame(width: 64, height: 64)
            .background(.white)
    }
}

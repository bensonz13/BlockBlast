//
//  Theme.swift
//  BlockBlast
//
//  Created by Student on 5/26/26.
//

import SwiftUI

struct Theme {
    static func backgroundGradient(for colorScheme: ColorScheme) -> LinearGradient {
        if colorScheme == .dark {
            return LinearGradient(
                colors: [Color(.systemGray6), Color(.systemGray5)],
                startPoint: .top,
                endPoint: .bottom
            )
        } else {
            return LinearGradient(
                colors: [Color(.systemGray5), Color(.systemGray4)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    static let cardBlueStart: Color = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
        ? UIColor(red: 0.18, green: 0.29, blue: 0.42, alpha: 1)
        : UIColor(red: 0.29, green: 0.44, blue: 0.65, alpha: 1)
    })
    static let cardBlueEnd: Color = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
        ? UIColor(red: 0.24, green: 0.35, blue: 0.48, alpha: 1)
        : UIColor(red: 0.42, green: 0.55, blue: 0.71, alpha: 1)
    })
    static let cardPinkStart: Color = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
        ? UIColor(red: 0.54, green: 0.29, blue: 0.42, alpha: 1)
        : UIColor(red: 0.75, green: 0.45, blue: 0.60, alpha: 1)
    })
    static let cardPinkEnd: Color = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
        ? UIColor(red: 0.60, green: 0.35, blue: 0.48, alpha: 1)
        : UIColor(red: 0.82, green: 0.58, blue: 0.69, alpha: 1)
    })

    static let boardBackground = Color(.systemBackground)
    static let boardCellEmpty = Color.clear
    static let boardCellColors: [Color] = [
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.29, green: 0.48, blue: 0.60, alpha: 1)
            : UIColor(red: 0.50, green: 0.69, blue: 0.83, alpha: 1)
        }),
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.29, green: 0.55, blue: 0.42, alpha: 1)
            : UIColor(red: 0.50, green: 0.77, blue: 0.60, alpha: 1)
        }),
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.60, green: 0.55, blue: 0.29, alpha: 1)
            : UIColor(red: 0.83, green: 0.75, blue: 0.50, alpha: 1)
        }),
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.48, green: 0.29, blue: 0.60, alpha: 1)
            : UIColor(red: 0.69, green: 0.50, blue: 0.80, alpha: 1)
        }),
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.60, green: 0.29, blue: 0.42, alpha: 1)
            : UIColor(red: 0.83, green: 0.50, blue: 0.60, alpha: 1)
        })
    ]
    static let boardGridLine = Color(.separator)
    static let pieceColors = boardCellColors

    static let ticTacToeX = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
        ? UIColor(red: 0.50, green: 0.69, blue: 0.83, alpha: 1)
        : UIColor(red: 0.29, green: 0.44, blue: 0.65, alpha: 1)
    })
    static let ticTacToeO = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
        ? UIColor(red: 0.82, green: 0.58, blue: 0.69, alpha: 1)
        : UIColor(red: 0.75, green: 0.45, blue: 0.60, alpha: 1)
    })
    static let ticTacToeButton = Color(.systemGray5)
    static let textPrimary = Color(.label)
    static let textSecondary = Color(.secondaryLabel)
    static let whiteFixed = Color.white
}

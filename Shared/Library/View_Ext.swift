//
//  View_Ext.swift
//  EvaluationManager
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 21/06/2022.
//  Copyright © 2022 Proagrica-AH. All rights reserved.
//

import SwiftUI


/*
 
 This debugger code example is taken from:
 https://www.swiftbysundell.com/articles/building-swiftui-debugging-utilities/
 Check the link for more info.
 */

// MARK: - Action
extension View {
    func debugAction(_ closure: () -> Void) -> Self {
        #if DEBUG
        closure()
        #endif

        return self
    }
}
extension View {
    func debugPrint(_ value: Any) -> Self {
        debugAction { print(value) }
    }
}

// MARK: - Modifier
extension View {
    func debugModifier<T: View>(_ modifier: (Self) -> T) -> some View {
        #if DEBUG
        return modifier(self)
        #else
        return self
        #endif
    }
}
extension View {
    func debugBorder(_ color: Color = .red, width: CGFloat = 1) -> some View {
        debugModifier {
            $0.border(color, width: width)
        }
    }

    func debugBackground(_ color: Color = .red) -> some View {
        debugModifier {
            $0.background(color)
        }
    }
}

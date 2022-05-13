//
//  HideKeybaordExtension.swift
//  DEVOTE
//
//  Created by Zeyad Badawy on 11/05/2022.
//

import SwiftUI


extension View {
#if canImport(UIKit)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        
    }
#endif
    
    func background(with color: Color) -> some View {
        background(GeometryReader { geometry in
            Rectangle().path(in: geometry.frame(in: .local)).foregroundColor(color)
        })
    }
}


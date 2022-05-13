//
//  BGImageView.swift
//  DEVOTE
//
//  Created by Zeyad Badawy on 11/05/2022.
//

import SwiftUI

struct BGImageView: View {
    var body: some View {
        Image("rocket")
            .resizable()
            .antialiased(true)
            .scaledToFill()
            .ignoresSafeArea()
    }
}

struct BGImageView_Previews: PreviewProvider {
    static var previews: some View {
        BGImageView()
    }
}

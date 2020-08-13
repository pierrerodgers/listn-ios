//
//  TextModifiers.swift
//  listn
//
//  Created by Pierre Rodgers on 13/8/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import SwiftUI

extension Text {
    func title() -> some View {
        self.modifier(Title())
    }
    func scoreText() -> some View {
        self.modifier(Score())
    }
}

struct Title : ViewModifier {
    func body(content: Content) -> some View {
        content.font(.system(size: 24, weight: .bold, design: .default))
    }
}

struct Score : ViewModifier {
    func body(content: Content) -> some View {
        content.font(.system(size: 24, weight: .bold, design: .default))
    }
}

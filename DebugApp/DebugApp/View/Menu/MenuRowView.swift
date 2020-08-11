//
//  MenuRowView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 04.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI

struct MenuRowView: View {

    let isSelected: Bool
    private let test: ContentState.Test

    init(test: ContentState.Test, isSelected: Bool) {
        self.test = test
        self.isSelected = isSelected
    }

    var body: some View {
        let title = self.test.rawValue.capitalizingFirstLetter()

        let text = Text(title)
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            .listRowInsets(EdgeInsets(top: 4, leading: 55, bottom: 4, trailing: 8))
            .multilineTextAlignment(.leading)

        if self.isSelected {
            return text.font(Font.body.bold())
        } else {
            return text.font(Font.body)
        }
    }
}

struct MenuRowView_Previews: PreviewProvider {
    static var previews: some View {
        MenuRowView(test: .plainMonotone, isSelected: false)
    }
}

private extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

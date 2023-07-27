//
//  View+.swift
//  Self Books
//
//  Created by softwave on 27/07/23.
//

import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
}

// run in terminal xcrun simctl list devicetypes for all the supported devices

enum Device: CaseIterable {
    case mac
    case iPhone14ProMax
    case iPadPro4th
}

extension View {
    @ViewBuilder func previewDevice(_ device: Device) -> some View {
        switch device {
        case .mac:
            previewDisplayName("Mac")
        case .iPhone14ProMax:
            previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
                .previewDisplayName("iPhone 14 Pro Max")
        case .iPadPro4th:
            previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
                .previewDisplayName("iPad Pro (11-inch) (4th generation)")
        }
    }
}

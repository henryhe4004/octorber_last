//
//  Card.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/10/13.
//

import Foundation

struct Card {
    let prompt: String
    let answer: String

    static var example: Card {
        Card(prompt: "扫一扫上面的二维码图案，入驻家庭", answer: "qrcode")
    }
}

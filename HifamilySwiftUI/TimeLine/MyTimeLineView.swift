//
//  MyTimeLineView.swift
//  HifamilySwiftUI
//
//  Created by 吴柏辉 on 2021/9/22.
//

import SwiftUI

struct MyTimeLineView: View {
    var body: some View {
        VStack {
            UpperLine()
            TimeLineRight()
        }
        
    }
}

struct MyTimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        MyTimeLineView()
    }
}

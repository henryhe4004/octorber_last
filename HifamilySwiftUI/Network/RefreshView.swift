//
//  RefreshView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/10/24.
//

import SwiftUI

class MyModel: ObservableObject {
    @Published var loading: Bool = false {
        didSet {
            if oldValue == false && loading == true {
                // 开始请求网络数据

                // 网络请求结束在主线程调用
                self.loading = false
            }
        }
    }
}

struct RefreshView: View {
    @State var loading = true
    var body: some View {
        RefreshableScrollView(refreshing: self.$loading) {
            // Scrollable contents go here
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }

        
    }
}

struct RefreshView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshView()
    }
}

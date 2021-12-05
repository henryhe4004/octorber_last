//
//  ContentVeiw.swift
//  HifamilySwiftUI
//
//  Created by 吴柏辉 on 2021/10/23.
//

import SwiftUI
import LeanCloud

struct ContentVeiw: View {
    
    @ObservedObject var lcmumber:LCMumber
    
    @Binding var selectedItem:Int
    @Binding var showSheet: Bool
    @Binding var txt:String
    var body: some View {
        Spacer()
        VStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
            
            Picker(selection: $selectedItem, label: Text("Picker")) {
                ForEach(0 ..< lcmumber.mumbersName.count) {
                    Text(self.lcmumber.mumbersName[$0])
                        .tag($0)
                }
            }
            Button("关闭窗体") {
                self.showSheet = false
            }
        }
    }
}

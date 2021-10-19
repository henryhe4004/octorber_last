//
//  HomeUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/10/13.
//

import SwiftUI

struct HomeUIView: View {
    @State private var index = 3
    @ObservedObject var familyTree:FamilyTree = FamilyTree()
    var body: some View {
        TabView(selection: $index) {
//            FamilyTreeView()
            ImageUIView().tabItem { Image(index == 1 ? "Iconly-Bulk-Activity" : "fIconly-Bulk-Activity") }.tag(1)
            LetterView().tabItem { Image(index == 2 ? "Iconly-Bulk-Message" : "fIconly-Bulk-Message") }.tag(2)
            HomeView().tabItem { Image( index == 3 ? "fIconly-Bulk-Home" : "Iconly-Bulk-Home") }.tag(3)
            LoveView(familyTree: familyTree).tabItem { Image( index == 4 ? "Iconly-Bulk-Heart" : "fIconly-Bulk-Heart") }.tag(4).onAppear(perform: {
                familyTree.queryUser()
            })
        
            MyTimeLineView().tabItem { Image(index == 5 ? "fIconly-Bulk-Chart" : "Iconly-Bulk-Chart") }.tag(5)
        
        }
        .navigationBarTitle("",displayMode: .inline)
        .navigationBarHidden(true)

    }
}

struct HomeUIView_Previews: PreviewProvider {
    static var previews: some View {
        HomeUIView()
    }
}

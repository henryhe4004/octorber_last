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
    @ObservedObject var album:Album = Album()
    @ObservedObject var miss:Miss = Miss()
    
    @ObservedObject var myLetter:MyLetter = MyLetter()
    
    var body: some View {
        TabView(selection: $index) {
//            FamilyTreeView()
            ImageUIView(album:album).tabItem { Image(index == 1 ? "Iconly-Bulk-Activity" : "fIconly-Bulk-Activity") }.tag(1).onAppear(perform: {
                    album.update()
                if #available(iOS 15.0, *) {
                    let appearance = UITabBarAppearance()
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
                    
            })
            LetterView(myLetter: myLetter).tabItem { Image(index == 2 ? "Iconly-Bulk-Message" : "fIconly-Bulk-Message") }.tag(2).onAppear(perform: {
                myLetter.queryAllMyLetter()
            })
            HomeView().tabItem { Image( index == 3 ? "fIconly-Bulk-Home" : "Iconly-Bulk-Home") }.tag(3).onAppear {
                if #available(iOS 15.0, *) {
                    let appearance = UITabBarAppearance()
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
            }
            LoveView(familyTree: familyTree,miss:miss).tabItem { Image( index == 4 ? "Iconly-Bulk-Heart" : "fIconly-Bulk-Heart") }.tag(4).onAppear(perform: {
                familyTree.queryUser()
                miss.queryMiss()
            })

            MyTimeLineView().tabItem { Image(index == 5 ? "fIconly-Bulk-Chart" : "Iconly-Bulk-Chart") }.tag(5)
        
        }
        .navigationBarTitle("",displayMode: .inline)
        .navigationBarHidden(true)

    }
}

struct HomeUIView_Previews: PreviewProvider {
    static var previews: some View {
        HomeUIView(album:Album())
    }
}

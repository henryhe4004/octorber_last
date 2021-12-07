//
//  ImagesContainer.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/12/6.
//

import SwiftUI

struct ImagesContainer: View {
    
    @State private var images = Generator.Images.random()
    @State private var settings = Settings.default(for: .images)
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            ImagesGrid(images: $images, settings: $settings)
                .customNavigationBarTitle(Text("WaterfallGrid"), displayMode: .inline)
                .customNavigationBarItems(leading: self.leadingNavigationBarItems(), trailing: trailingNavigationBarItems())
        }
        .sheet(isPresented: $showSettings, content: { SettingsView(settings: self.$settings, screen: .images, isPresented: self.$showSettings) })
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func leadingNavigationBarItems() -> some View {
        Button(action: { self.showSettings = true }) {
            Image(systemName: "gear")
        }
    }
    
    private func trailingNavigationBarItems() -> some View {
        HStack() {
            Button(action: { self.images = Generator.Images.random() }) {
                Image(systemName: "gobackward")
            }
        }
    }
}

struct ImagesContainer_Previews: PreviewProvider {
    static var previews: some View {
        ImagesContainer()
    }
}


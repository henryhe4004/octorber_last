//
//  HifamilySwiftUIApp.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/13.
//

import SwiftUI
import LeanCloud

@main

struct HifamilySwiftUIApp: App {
   
    init(){
        LCApplication.logLevel = .all
        var config = LCApplication.Configuration()
        config.isObjectRawDataAtomic = true
        let appid = "2fFgnH5uGXYktafjWdAWSoUt-gzGzoHsz"
        let appkey = "jUHdNSwloytcJyHtgKH3jg7T"
        let url = "https://2ffgnh5u.lc-cn-n1-shared.com"
        do { try LCApplication.default.set(id: appid, key: appkey, serverURL: url) }
        catch { print(error) }
    }
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    
    //不知道怎么用
    struct Validation<Value>: ViewModifier {
        var value: Value
        var validator: (Value) -> Bool
        
        func body(content: Content) -> some View {
            Group {
                if validator(value) {
                    content
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green).padding()
                } else {
                    content
                    Image(systemName: "xmark.octagon.fill").foregroundColor(.red).padding()
                }
            }
        }
    }
}

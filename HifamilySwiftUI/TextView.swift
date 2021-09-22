//
//  TextView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/20.
//

import SwiftUI
import UIKit

struct TextView: UIViewRepresentable{
    @Binding var text: String

       func makeCoordinator() -> Coordinator {
           Coordinator(self)
       }

       func makeUIView(context: Context) -> UITextView {

           let myTextView = UITextView()
           myTextView.delegate = context.coordinator

           myTextView.font = UIFont(name: "HelveticaNeue", size: 15)
           myTextView.isScrollEnabled = true
           myTextView.isEditable = true
           myTextView.isUserInteractionEnabled = true
        myTextView.backgroundColor = UIColor(white: 0, alpha: 0.01)

           return myTextView
       }

       func updateUIView(_ uiView: UITextView, context: Context) {
           uiView.text = text
       }

       class Coordinator : NSObject, UITextViewDelegate {

           var parent: TextView

           init(_ uiTextView: TextView) {
               self.parent = uiTextView
           }

           func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
               return true
           }

           func textViewDidChange(_ textView: UITextView) {
               print("text now: \(String(describing: textView.text!))")
               self.parent.text = textView.text
           }
       }
}

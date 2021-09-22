//
//  albumUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/9/19.
//

import SwiftUI



struct albumUIView: View {
    @ObservedObject var imgTest : Image1 = Image1()
    @Binding var detailImage : String
    @Binding var detailText : String
    @Binding var isSelected : Bool
    var items : [GridItem] = [
        GridItem(GridItem.Size.flexible(),spacing: 5),
        GridItem(GridItem.Size.flexible(),spacing: 5),
        GridItem(GridItem.Size.flexible(),spacing: 5)
        
    ]
    
    var body: some View {
        
        VStack{
            ForEach(0..<imgTest.img.count){ index in
            HStack{
                HStack{
                }
                .frame(width: 3, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color("AccentColor"))
                VStack{
                Text("2021年8月\(imgTest.date[index])日")
                    .kerning(2.0)
                    .frame(width: 200, height: 25, alignment: .topLeading)
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 115/255, green: 115/255, blue: 115/255))
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
                    )
                Text("今日有\(imgTest.date[index]-20)人上传照片").font(.system(size: 14))
                    .frame(width: 200, height: 20, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                }
                Spacer()
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
        
            LazyVGrid(columns: items, content: {
                ForEach(1..<10){
                    indexsecond in
                    Button(action:{
                        isSelected = true
                        detailImage = imgTest.img[index]+"\(indexsecond)"
                        detailText = "弟弟，你还记得那天你小学四年级军训的时候要上台表演，在台下紧张的等待，我悄悄给你拍的照片。"
                    }){
                        Image("\(imgTest.img[index])\(indexsecond)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100, alignment: .center)
                            .cornerRadius(20)
                    }
                }
            })
        }
        }
    }
}

//struct albumUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        albumUIView(detailImage: String, detailText: String)
//    }
//}

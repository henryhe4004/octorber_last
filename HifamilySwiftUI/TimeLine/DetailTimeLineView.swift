//
//  DetailTimeLineView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/12/5.
//

import SwiftUI
import Kingfisher

struct DetailTimeLineView: View {
    @ObservedObject var liner:TimeLinerOnly
    @Binding var isSelected : Bool
    var items : [GridItem] = [
        GridItem(GridItem.Size.flexible(),spacing: 1),
        GridItem(GridItem.Size.flexible(),spacing: 1),
        GridItem(GridItem.Size.flexible(),spacing: 1)
    ]
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false){
                
                Image(systemName: "arrowshape.turn.up.left.fill")
                    .resizable(resizingMode: .tile)
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(Color("AccentColor"))
                    .onTapGesture {
                        isSelected = false
                    }
                    .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .offset(x: -120, y: 0)
                VStack{
                    
                    HStack {
                        Image("Hi family").padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 0))
                        Spacer()
                    }
                    HStack{
                        Text("\(liner.liner.eventContent)").frame( alignment: .topLeading)
//                            .offset(x: 30, y: 0)
                            .padding(EdgeInsets(top: 10, leading: 40, bottom: 0, trailing: 40))
                    }
                    HStack{
                    LazyVGrid(columns: items, content: {
                        ForEach(0..<liner.liner.img.count,id: \.self){
                            index in
                            KFImage.url(URL(string:liner.liner.img[index]))
                                .placeholder { Image("cat_walk") }
                            //                              .placeholder(UIImageView().image(UIImage("")))
                            //                              .placeholder(UIImage("AppIcon"))
                            //                              .setProcessor(processor)
                                .loadDiskFileSynchronously()
//                                .cacheMemoryOnly()
                                .cacheOriginalImage()
                                .fade(duration: 0.25)
                            //                              .lowDataModeSource(.network(lowResolutionURL))
                                .onProgress { receivedSize, totalSize in  }
                                .onSuccess { result in  }
                                .onFailure { error in }
                                .resizable()
                                .cornerRadius(8)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80, alignment: .center)
                                .padding(EdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20))
                        }
                    })
                    }
//                    Image(detailImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 250)
//                        .cornerRadius(20)
//                        .overlay(RoundedRectangle(cornerRadius: 15.0, style: .continuous   ).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
                    HStack{
                        Text("时光记录人: \(liner.liner.eventPerson)")
                            .foregroundColor(Color.black)
                            .font(.system(size: 14))
                        Spacer()
                    }.padding(EdgeInsets(top: 10, leading: 20, bottom: 5, trailing: 0))
//                    Text(detailText).foregroundColor(Color(red: 115/255, green: 115/255, blue: 115/255))
//                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 15))
//                        .lineSpacing(12.0)
                    HStack{
                        Spacer()
                        Text("上传时间：\(liner.liner.eventTime.formatted(.iso8601.month().day().year().dateSeparator(.dash)))").foregroundColor(Color.black).padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 15))
                            .font(.system(size: 15))
                    }
                    
                }
                .frame(width: 280)
                .background(Color(white: 0.99))
                .overlay(RoundedRectangle(cornerRadius: 15.0, style: .continuous   ).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
                .cornerRadius(15)
                .shadow(color: .gray, radius: 10, x: 0, y: 3)
                .animation(.easeInOut)
            }.frame(width: 500,alignment: .center)
                .offset(x:-geometry.size.width/6, y: geometry.size.height/12)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 20, trailing: 15))
        }
    }
}

//struct DetailTimeLineView_Previews: PreviewProvider {
////    @State var liner:Liner = Liner(eventContent: "", eventIcon: 0, eventPerson: "", eventTime: Date(), eventType: "", familyId: 0, isWarn: false, objectId: "", img: [])
//    static var previews: some View {
//        DetailTimeLineView(liner:Liner(eventContent: "", eventIcon: 0, eventPerson: "", eventTime: "", eventType: "", familyId: 0, isWarn: false, objectId: "", img: []),isSelected: .constant(true))
//    }
//}

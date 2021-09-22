//
//  TimeLineVeiw.swift
//  TimeLine
//
//  Created by 吴柏辉 on 2021/9/21.
//

import SwiftUI

public struct TimeLineView<LeftView: View, RightView: View>: View {
    
    var leftWidth: CGFloat { UIScreen.main.bounds.size.width * 0.5 }
    var rightWidth: CGFloat { UIScreen.main.bounds.size.width - leftWidth }
    
    private let leftView: LeftView
    private let rightView: RightView
    
    public init(@ViewBuilder leftView: () -> LeftView, @ViewBuilder rightView: () -> RightView) {
        self.leftView = leftView()
        self.rightView = rightView()
    }
    
    public var body: some View {
        
        HStack(alignment: .top) {
           
            VStack(alignment: .trailing, spacing: 2) {
                leftView
            }
            .minimumScaleFactor(0.5)
            .padding(.horizontal, 10)
            .frame(width: leftWidth, alignment: .trailing)
            .overlay(
                right_icon()
            )
            
            VStack(alignment: .leading, spacing: 5) {
                rightView
            }
            .frame(width: rightWidth, alignment: .leading)
            
            
        }
        .background(
            GeometryReader { geo in
                Path { path in
                    path.move(to: CGPoint(x: leftWidth, y: 0))
                    path.addLine(to: CGPoint(x: leftWidth, y: geo.size.height + 10)) // 每块之间的距离2（有2个，数值需要一样）
                }
                .stroke(Color("TimeLineColor"), lineWidth: 5) // 时间轴的宽度
                .padding(.top, 7)
            }
        )
    }
    
    // 修改坐标轴上点的函数
    private func right_icon() -> some View{
        VStack {
            Image("timeline-right")
                .resizable()
                .frame(width: 170, height: 76)
                .font(.footnote)
                .offset(x: UIScreen.main.bounds.size.width  * 0.5 + 48, y: 250)
                .scaleEffect(0.5)
            Image("timeline-left")
                .resizable()
                .frame(width: 170, height: 76)
                .font(.footnote)
                .offset(x: 150, y: 300)
                .scaleEffect(0.5)
        }
    }

}


struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TimeLineRight()
        }
    }
}

struct UpperLine: View {
    var body: some View {
        HStack {
            Image("Iconly-Bulk-Setting")
                .resizable()
                .frame(width:23,
                       height:23,
                       alignment:.center)
            Spacer()
            Text("写家书")
                .foregroundColor(Color.black)
                .font(.system(size: 22))
            Spacer()
            Text("寄出")
                .foregroundColor(Color.black)
                .font(.system(size: 22))
        }.padding()
    }
}

struct TimeLineRight: View {
    var body: some View {
        ScrollView {
            Spacer().frame(width: 20)
            VStack(spacing: 10) {   // 每块之间的距离1（有2个，数值需要一样）
            ForEach(1..<8) { _ in // 时间轴整体纵向长度
                TimeLineView {
                } rightView: {
                    VStack (alignment: .trailing){
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 63, height: 46).foregroundColor(Color("TimeLineColor"))
                                .offset(x:-144, y: 96)
                            Image("imagew")
                                .resizable()
                                .frame(width: 17, height: 17)
                                .offset(x:-130,y:87)
                            Text("你好")
                                .foregroundColor(.white).font(.system(size: 14))
                                .frame(width: 50, height: 20)
                                .offset(x:-155,y:87)
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 116, height: 104)
                                    .shadow(color: Color("shadowColor"), radius: 8, x: 1, y: 1)
                                    .foregroundColor(.white)
                                VStack {
                                    Text("全家看电影全家看电影")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color("wTimeLineFontColorGray"))
                                        .frame(width: 100, height: 50, alignment: .topLeading)
                                        .offset(x: 5,y:3)
                                    Text("2021年7月28日")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color("shadowColor"))
                                        .offset(x: 0, y: 4)
                                }
                            }.offset(x: -170, y: 150)
                            Text("创建人：浩宇")
                                .foregroundColor(Color("fontColor"))
                                .font(.system(size: 11))
                                .offset(x: -165, y: 233)
                                .frame(width: 100, height: 25, alignment: .topTrailing)
                            Text("创建时间：2021.07.21")
                                .foregroundColor(Color("fontColor"))
                                .font(.system(size: 11))
                                .offset(x: -170, y: 241)
                        }
                        
                    }
                
                    
                VStack(alignment: .leading) {
                        // 我们的原UI
                        ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 63, height: 46).foregroundColor(Color("TimeLineColor"))
                    .offset(x: -27, y: -55)
                Image("imagew")
                    .resizable().frame(width: 17, height: 17).offset(x: -42, y: -64)
                Text("开心")
                    .offset(x: -15, y: -64).foregroundColor(.white).font(.system(size: 14))
                    .frame(width: 50, height: 20)
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 116, height: 104)
                        .shadow(color: Color("shadowColor"), radius: 8, x: 1, y: 1)
                        .foregroundColor(.white)
                    VStack {
                        Text("全家看电影全家看电影")
                            .font(.system(size: 18))
                            .foregroundColor(Color("wTimeLineFontColorGray"))
                            .frame(width: 100, height: 50, alignment: .topLeading)
                            .offset(x: 5,y:3)
                        Text("2021年7月28日")
                            .font(.system(size: 12))
                            .foregroundColor(Color("shadowColor"))
                            .offset(x: 0, y: 4)
                    }}}
            VStack {
                Text("创建人：妍妍")
                    .foregroundColor(Color("fontColor"))
                    .font(.system(size: 11))
                    .frame(width: 100, height: 25)
                    .offset(x: -22, y: -10)
                Text("创建时间：2021.07.21")
                    .foregroundColor(Color("fontColor"))
                    .font(.system(size: 11))
                    .offset(x: 0, y: -15)
            }.padding(EdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 0))
            }.padding(EdgeInsets(top: -40, leading: 40, bottom: 0, trailing: 0))
                    }
                }
            }
        }
    }
}

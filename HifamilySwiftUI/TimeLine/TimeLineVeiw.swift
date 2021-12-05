//
//  TimeLineVeiw.swift
//  TimeLine
//
//  Created by 吴柏辉 on 2021/9/21.
//

import SwiftUI
import LeanCloud

struct Liner{
    var eventContent:String
    var eventIcon:Int
    var eventPerson:String
    var eventTime:String
    var eventType:String
    var familyId:Int
    var isWarn:Bool
    var objectId:String
    var img:[String]
}
func checkDay1(date:Date)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    return dateFormatter.string(from: date)
}
final class TimeLiner: ObservableObject {
    @Published  var familyId:Int
    @Published  var lineRight:[Liner]
    @Published  var lineLeft:[Liner]
    @Published  var count:Int
    init() {
        familyId = 0;
        lineRight = [];
        lineLeft = [];
        count = 0;
    }
    func queryFamilyId(){
        let user = LCApplication.default.currentUser?.objectId?.stringValue!
        let query = LCQuery(className: "_User")
        query.whereKey("objectId", .equalTo(user!))
        _ = query.getFirst() { result in
            switch result {
            case .success(object: let person):
                self.familyId = (person.familyTreeId?.intValue!)!
                self.queryLine()
                break
            case .failure(error: let error):
                print(error)
            }
        }
    }

    func queryLine(){
        let query = LCQuery(className: "TimeLine")
        query.whereKey("familyId",.equalTo(self.familyId))
//        print("123123123saddasd13afsfgsdgewrgerg\(self.treeId)")
        query.whereKey("createdAt",.descending)
//        query.skip=self.skip
//        query.limit=20
        _ = query.find() { result in
            switch result {
            case .success(objects: let person):
                print("代码执行3213123123123123123123123123123123123")
                print(person)
//                self.skip=self.skip+20
                var index = 0;
                for item in person{
                    index+=1
                    var line = Liner(eventContent: (item.eventContent?.stringValue!)!, eventIcon: (item.eventIcon?.intValue!)!, eventPerson: (item.eventPerson?.stringValue!)!, eventTime: checkDay1(date: (item.eventTime?.dateValue!)!), eventType:(item.eventType?.stringValue!)!, familyId: (item.familyId?.intValue!)!, isWarn: (item.isWarn?.boolValue!)!, objectId: (item.objectId?.stringValue!)!, img: [])
                    let query2 = LCQuery(className: "TimeLineAndImage")
                    query2.whereKey("timeLineObjectId", .equalTo(item.objectId!))
                    _ = query2.find(){result in
                        switch result{
                        case .success(objects: let img1):
                            for item in img1{
                                line.img.append((item.imageUrl?.stringValue!)!)
                                print("😊\(line.img.count)")
                            }
                            break
                        case .failure(error: let error):
                            print(error)
                        }
                    }
                    if(index%2==1){
                        self.lineRight.append(line)
                        print("😊💗\(line.img.count)")
                        self.count = max(self.count,self.lineRight.count)
                    }else{
                        self.lineLeft.append(line)
                        self.count = max(self.count,self.lineLeft.count)
                    }
                }
                break
            case .failure(error: let error):
                print(error)
            }
    }
    }

}


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


//struct TimeLineView_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            TimeLineRight(timeLiner: TimeLiner, body: <#T##View#>)
//        }
//    }
//}

struct TimeLineRight: View {
    @ObservedObject var timeLiner:TimeLiner
    @State var isSelected : Bool = false
    @State var line : Liner = Liner(eventContent: "", eventIcon: 0, eventPerson: "", eventTime: "", eventType: "", familyId: 0, isWarn: false, objectId: "", img: [])
    var body: some View {
        ZStack{
        ScrollView {
            Spacer().frame(width: 20)
            VStack(spacing: 10) {   // 每块之间的距离1（有2个，数值需要一样）
                ForEach(0..<timeLiner.count,id: \.self) { index in // 时间轴整体纵向长度
                TimeLineView {
                } rightView: {
                    Button(action:{
                        isSelected = true;
                        line.eventContent = timeLiner.lineRight[index].eventContent
                        line.eventIcon = timeLiner.lineRight[index].eventIcon
                        line.eventPerson = timeLiner.lineRight[index].eventPerson
                        line.eventType = timeLiner.lineRight[index].eventType
                        line.familyId = timeLiner.lineRight[index].familyId
                        line.isWarn = timeLiner.lineRight[index].isWarn
                        print("😊\(timeLiner.lineRight[index].img.count)")
                        line.img = timeLiner.lineRight[index].img
                    }){
                    VStack (alignment: .trailing){
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 63, height: 46).foregroundColor(Color("TimeLineColor"))
                                .offset(x:-144, y: 96)
//                            Image("eventIcon\(timeLiner.lineRight[index].eventIcon)")
//                                .resizable()
//                                .foregroundColor(Color.white)
//                                .frame(width: 17, height: 17)
//                                .offset(x:-130,y:87)
                            Text(timeLiner.lineRight[index].eventType)
                                .foregroundColor(.white).font(.system(size: 14))
                                .frame(width: 50, height: 20)
                                .offset(x:-140,y:87)
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 116, height: 104)
                                    .shadow(color: Color("shadowColor"), radius: 8, x: 1, y: 1)
                                    .foregroundColor(.white)
                                VStack {
                                    Text(timeLiner.lineRight[index].eventContent)
                                        .font(.system(size: 16))
                                        .foregroundColor(Color("wTimeLineFontColorGray"))
                                        .frame(width: 100, height: 50, alignment: .topLeading)
                                        .offset(x: 5,y:3)
//                                    Text("2021年7月28日")
//                                        .font(.system(size: 12))
//                                        .foregroundColor(Color("shadowColor"))
//                                        .offset(x: 0, y: 4)
                                }
                            }.offset(x: -170, y: 150)
//                            Text("创建人：\(timeLiner.lineRight[index].eventPerson)")
//                                .foregroundColor(Color("fontColor"))
//                                .font(.system(size: 11))
//                                .offset(x: -165, y: 233)
//                                .frame(width: 100, height: 25, alignment: .topTrailing)
//                            Text("创建时间：")
//                                .foregroundColor(Color("fontColor"))
//                                .font(.system(size: 11))
//                                .offset(x: -170, y: 241)
                        }
                    }
                }
                
                    Button(action:{
                        isSelected = true;
                        line.eventContent = timeLiner.lineLeft[index].eventContent
                        line.eventIcon = timeLiner.lineLeft[index].eventIcon
                        line.eventPerson = timeLiner.lineLeft[index].eventPerson
                        line.eventType = timeLiner.lineLeft[index].eventType
                        line.familyId = timeLiner.lineLeft[index].familyId
                        line.isWarn = timeLiner.lineLeft[index].isWarn
                        line.img = timeLiner.lineLeft[index].img
                    }){
                VStack(alignment: .leading) {
                        // 我们的原UI
                        ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 63, height: 46).foregroundColor(Color("TimeLineColor"))
                    .offset(x: -27, y: -55)
//                Image("eventIcon\(timeLiner.lineLeft[index].eventIcon)")
//                    .resizable().frame(width: 17, height: 17).offset(x: -42, y: -64)
                Text(timeLiner.lineLeft[index].eventType)
                    .offset(x: -30, y: -62).foregroundColor(.white).font(.system(size: 14))
                    .frame(width: 50, height: 20)
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 116, height: 104)
                        .shadow(color: Color("shadowColor"), radius: 8, x: 1, y: 1)
                        .foregroundColor(.white)
                    VStack {
                        Text(timeLiner.lineLeft[index].eventContent)
                            .font(.system(size: 16))
                            .foregroundColor(Color("wTimeLineFontColorGray"))
                            .frame(width: 100, height: 50, alignment: .topLeading)
                            .offset(x: 5,y:3)
//                        Text("2021年7月28日")
//                            .font(.system(size: 12))
//                            .foregroundColor(Color("shadowColor"))
//                            .offset(x: 0, y: 4)
                    }}}
            VStack {
//                Text("创建人\(timeLiner.lineLeft[index].eventPerson)")
//                    .foregroundColor(Color("fontColor"))
//                    .font(.system(size: 11))
//                    .frame(width: 100, height: 25)
//                    .offset(x: -22, y: -10)
//                Text("创建时间：")
//                    .foregroundColor(Color("fontColor"))
//                    .font(.system(size: 11))
//                    .offset(x: 0, y: -15)
            }.padding(EdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 0))
                }
            }.padding(EdgeInsets(top: -40, leading: 40, bottom: 0, trailing: 0))
                    }
                }
            }
        }
            if(isSelected){
                Rectangle().fill(Color.gray).opacity(0.5)
                DetailTimeLineView(liner: $line, isSelected:$isSelected)
            }
        }
    }
}

import SwiftUI
import Kingfisher

struct FlippingView: View {
      @State private var flipped = false
      @State private var animate3d = false
      @Binding var isSelected : Bool
      @ObservedObject var album:Album
      @Binding var selectWho:Int
      var body: some View {

            return VStack {
                Image(systemName: "arrowshape.turn.up.left.fill")
                    .resizable(resizingMode: .tile)
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(Color("AccentColor"))
                    .onTapGesture {
                        isSelected = false
                    }
                    .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .offset(x: -160, y: 120)
                  Spacer()

                  ZStack() {
                        FrontCard(album: album, selectWho: $selectWho).opacity(flipped ? 0.0 : 1.0)
                        BackCard(album: album, selectWho: $selectWho).opacity(flipped ? 1.0 : 0.0)
                  }
                  .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : 0, axis: (x: 1, y: 0)))
                  .onTapGesture {
                        withAnimation(Animation.linear(duration: 0.8)) {
                              self.animate3d.toggle()
                        }
                  }
                  Spacer()
            }
      }
}

struct FlipEffect: GeometryEffect {

      var animatableData: Double {
            get { angle }
            set { angle = newValue }
      }

      @Binding var flipped: Bool
      var angle: Double
      let axis: (x: CGFloat, y: CGFloat)

      func effectValue(size: CGSize) -> ProjectionTransform {

            DispatchQueue.main.async {
                  self.flipped = self.angle >= 90 && self.angle < 270
            }
            let tweakedAngle = flipped ? -180 + angle : angle
            let a = CGFloat(Angle(degrees: tweakedAngle).radians)

            var transform3d = CATransform3DIdentity;
            transform3d.m34 = -1/max(size.width, size.height)

            transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
            transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)

            let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))

            return ProjectionTransform(transform3d).concatenating(affineTransform)
      }
}

struct FrontCard : View {
    @ObservedObject var album:Album
    @Binding var selectWho:Int
      var body: some View {
        VStack{
            KFImage.url(URL(string:album.dateNeed[selectWho].image))
               
//                              .placeholder(UIImage("AppIcon"))
//                              .setProcessor(processor)
                      .loadDiskFileSynchronously()
                      .cacheMemoryOnly()
                      .fade(duration: 0.25)
//                              .lowDataModeSource(.network(lowResolutionURL))
                      .onProgress { receivedSize, totalSize in  }
                      .onSuccess { result in  }
                      .onFailure { error in }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 350,height:350)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 15.0, style: .continuous   ).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
        } .frame(width: 350,height: 350)
        .background(Color(white: 0.99))
        .overlay(RoundedRectangle(cornerRadius: 15.0, style: .continuous   ).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
        .cornerRadius(15)
        .shadow(color: .gray, radius: 10, x: 0, y: 3)
        .animation(.easeInOut)
//            Text("One thing is for sure – a sheep is not a creature of the air.").padding(5).frame(width: 250, height: 150, alignment: .center).background(Color.yellow)
      }
}

struct BackCard : View {
    @ObservedObject var album:Album
    @Binding var selectWho:Int
      var body: some View {
        VStack{
            HStack {
                Image("Hi family").padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 0))
                Spacer()
            }
        HStack{
            Text("时光记录人: \(album.dateNeed[selectWho].person)")
                .foregroundColor(Color("AccentColor"))
                .font(.system(size: 38))
            Spacer()
        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 0))
                    ScrollView(.vertical){
                        Text("\(album.dateNeed[selectWho].Content)").foregroundColor(Color(red: 115/255, green: 115/255, blue: 115/255))
                            .multilineTextAlignment(.leading)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 15))
            .font(.system(size: 25))
                    }
//                        .lineSpacing(12.0)
        HStack{
            Spacer()
            Text("上传时间:\(album.dateNeed[selectWho].createdAt)").foregroundColor(Color("AccentColor")).padding(EdgeInsets(top: 5, leading: 0, bottom: 1, trailing: 15))
                .font(.system(size: 20))
        }
      } .frame(width: 350,height: 350)
        .background(Color(white: 0.99))
        .overlay(RoundedRectangle(cornerRadius: 15.0, style: .continuous   ).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
        .cornerRadius(15)
        .shadow(color: .gray, radius: 10, x: 0, y: 3)
        .animation(.easeInOut)
      }
        
      }


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        FlippingView(isSelected: .constant(true), album: Album(),selectWho: .constant(1))
    }
}

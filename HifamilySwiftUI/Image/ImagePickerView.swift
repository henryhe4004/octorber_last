//
//  ImagePickerView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/9/18.
//

import SwiftUI
import YPImagePicker
import LeanCloud
import AVFoundation

struct ImagePickerView: View {
    @State private var showYPImagePickerView = true
    @Binding var url : String
    @ObservedObject var MyImage : Imagepicker
    var body: some View {
           VStack {
            MediaPicker( url1 : $url, MyImage: MyImage)
           }
       }
}

func resizedImage(image : UIImage) -> UIImage? {
    let boundingRect = CGRect(x: 0, y: 0, width: 150, height:CGFloat.greatestFiniteMagnitude)


    let aspectRect = AVMakeRect(aspectRatio: image.size, insideRect: boundingRect)

    let renderer = UIGraphicsImageRenderer(size: aspectRect.size)

    let img = renderer.image { (context) in
        image.draw(in: CGRect(origin: .zero, size: aspectRect.size))
    }
   return img
}

struct MediaPicker: UIViewControllerRepresentable {
    @Binding var url1 : String
    @ObservedObject var MyImage : Imagepicker
    func makeUIViewController(context: Context) -> YPImagePicker {
        var config = YPImagePickerConfiguration()
        //是否可以滑动
        config.isScrollToChangeModesEnabled = false
        //是否只能拍摄正方形
        config.onlySquareImagesFromCamera = false
        //默认打开前置摄像头
        config.usesFrontCamera = false
        //相册名
        config.albumName = "Hi family"
        //默认打开为相册
        config.startOnScreen = YPPickerScreen.library
        //展示啥
        config.screens = [.library,.photo,.video]
        //提供裁剪
        config.showsCrop = .rectangle(ratio: 1)
        //图片大小
        config.targetImageSize = YPImageSize.original
        //加功能
        config.overlayView = UIView()
        //是否隐藏状态栏
        config.hidesStatusBar = false
        config.hidesBottomBar = true
        config.bottomMenuItemSelectedTextColour = UIColor(Color("AccentColor"))
        config.bottomMenuItemUnSelectedTextColour = UIColor(Color.white)
        //最大5倍变焦
        config.maxCameraZoomFactor = 5.0
        config.library.defaultMultipleSelection = true
        //图片和视频
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.maxNumberOfItems = 9
        //不要预处理为最近一张图片
        config.library.preSelectItemOnMultipleSelection = false;
        config.library.spacingBetweenItems = 3
        config.library.skipSelectionsGallery = false
        
        config.gallery.hidesRemoveButton = false
        
        
        let picker = YPImagePicker(configuration: config)

        picker.didFinishPicking { [unowned picker] items,  cancelled in
            if cancelled{
                print("用户按了取消按钮")
            }else{
            for item in items {
                switch item {
                case let .photo(photo) :
                    do {
                        let image123 = resizedImage(image: photo.modifiedImage!)
                        let file = LCFile(payload: .data(data: (image123?.pngData()!)!))
                        _ = file.save { result in
                            switch result {
                            case .success:
                                if let value = file.url?.value {
                                    url1 = value
                                    print("文件保存完成。URL: \(value)")
                                }
                            case .failure(error: let error):
                                print(error)
                            }
                        }
                        MyImage.addImage( img1 : photo.modifiedImage ??  photo.originalImage)
                        
                    }
                case .video(let video) :
                        print(video)
                }
            }
                
             
            }
            picker.dismiss(animated: true, completion: nil)
        }
    
        return picker
    }
    
    func updateUIViewController(_ uiViewController: YPImagePicker, context: Context) {}
    
    typealias UIViewControllerType = YPImagePicker
    
}
//struct ImagePickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePickerView()
//    }
//}

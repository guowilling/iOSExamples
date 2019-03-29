
import UIKit
import CoreImage

extension UIImage {
    
    /// 创建普通二维码
    ///
    /// - Parameters:
    ///   - size: 二维码大小
    ///   - dataStr: 二维码数据
    /// - Returns: 二维码图片
    class func createQRCode(size: CGFloat, dataStr: String) -> UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = dataStr.data(using: .utf8)
        filter?.setValue(data, forKey: "inputMessage")
        guard let ciImage = filter?.outputImage else {
            return nil
        }
        return self.createNonInterpolatedUIImage(image: ciImage, size: size)
    }
    
    /// 创建自定义二维码
    ///
    /// - Parameters:
    ///   - size: 二维码大小
    ///   - dataStr: 二维码数据
    ///   - iconImage: 二维码中自定义图标
    ///   - iconImageType: 二维码中自定义图标边框类型
    ///   - iconImageSize: 二维码中自定义图标大小
    /// - Returns: 二维码图片
    class func createCustomizeQRCode(
        size: CGFloat,
        dataStr: String,
        iconImage: UIImage,
        iconImageSize: CGFloat) -> UIImage?
    {
        guard let qrCodeImage = UIImage.createQRCode(size: size, dataStr: dataStr) else {
            return nil
        }
        return UIImage.composite(bgImage: qrCodeImage, iconImage: iconImage, iconSize: iconImageSize)
    }
    
    /// 根据 CIImage 生成指定大小的 UIImage
    ///
    /// - Parameters:
    ///   - image: CIImage
    ///   - size: 图片大小
    /// - Returns: UIImage
    private class func createNonInterpolatedUIImage(image: CIImage, size: CGFloat) -> UIImage? {
        let extent = image.extent.integral
        let scale = min(size / extent.width, size / extent.height)
        let width = extent.width * scale
        let height = extent.height * scale
        let cs = CGColorSpaceCreateDeviceGray()
        let context = CIContext(options: nil);
        let bitmapImage = context.createCGImage(image, from: extent)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        guard let bitmapRef = CGContext(data: nil,
                                        width: Int(width),
                                        height: Int(height),
                                        bitsPerComponent: 8,
                                        bytesPerRow: 0,
                                        space: cs,
                                        bitmapInfo: bitmapInfo.rawValue) else {
                                            return nil
        }
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale,y: scale)
        bitmapRef.draw(bitmapImage!, in: extent)
        guard let scaledImage = bitmapRef.makeImage() else {
            return nil
        }
        return UIImage(cgImage: scaledImage)
    }
    
    /// 添加背景
    ///
    /// - Parameters:
    ///   - bgImage: 背景图片
    ///   - bgImageSize: 背景图片大小
    ///   - qrCode: 二维码图片
    /// - Returns: 添加背景后的二维码图片
    class func addQRCodeBg(bgImage: UIImage, bgImageSize: CGFloat, qrCode: UIImage) -> UIImage? {
        let compressImage = UIImage.compress(sourceImage: bgImage, destSize: CGSize(width: bgImageSize, height: bgImageSize))!
        return  UIImage.composite(bgImage: compressImage, iconImage: qrCode, iconSize: qrCode.size.width)
    }
    
    /// 剪切圆形图片
    private class func circular(sourceImage: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(sourceImage.size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.addEllipse(in: CGRect(x: 0, y: 0, width: sourceImage.size.width, height: sourceImage.size.height))
        ctx?.clip()
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: sourceImage.size.width, height: sourceImage.size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    /// 比例缩放图片
    private class func compress(sourceImage: UIImage, destSize: CGSize) -> UIImage? {
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = destSize.width
        let targetHeight = destSize.height
        var scaleFactor:CGFloat = 0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPoint(x: 0, y: 0)
        if !__CGSizeEqualToSize(imageSize, destSize) {
            let widthFactor:CGFloat = CGFloat(targetWidth / width)
            let heightFactor:CGFloat = CGFloat(targetHeight / height)
            if (widthFactor > heightFactor) {
                scaleFactor = widthFactor
            } else {
                scaleFactor = heightFactor
            }
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            if (widthFactor > heightFactor) {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            } else if(widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
        UIGraphicsBeginImageContext(destSize)
        let thumbnailRect = CGRect(origin: thumbnailPoint, size: CGSize(width: scaledWidth, height: scaledHeight))
        sourceImage.draw(in: thumbnailRect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    /// 合成图片
    private class func composite(bgImage: UIImage, iconImage: UIImage, iconSize: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(bgImage.size)
        bgImage.draw(in: CGRect(x: 0, y: 0, width: bgImage.size.width, height: bgImage.size.height))
        let imageX: CGFloat = (bgImage.size.width - iconSize) * 0.5
        let imageY: CGFloat = (bgImage.size.height - iconSize) * 0.5
        iconImage.draw(in: CGRect(x: imageX, y: imageY, width: iconSize, height: iconSize))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
}

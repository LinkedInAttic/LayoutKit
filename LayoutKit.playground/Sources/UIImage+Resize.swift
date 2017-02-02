import UIKit

extension UIImage {

    /// Resizing with preserving aspect-ratio.
    public func resize(width: CGFloat) -> UIImage {
        let image = self
        let scale = width / image.size.width
        let height = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

}

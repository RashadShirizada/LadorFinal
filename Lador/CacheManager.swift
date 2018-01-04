
import UIKit
import os.log

class CacheManager {
    
    //MARK: Properties
    let image: UIImage
    let identifier: String
    
    init(image: UIImage, identifier: String) {
        self.image = image
        self.identifier = identifier
    }
    
    static func set(image: UIImage, identifier: String) {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        let fileName = cachesDirectory.appendingPathComponent(identifier + ".jpg")
        try? imageData?.write(to: fileName)
        //print("Saved to cache: " + fileName.path)
    }
    
    static func get(identifier: String) -> UIImage? {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        
        if FileManager.default.fileExists(atPath: cachesDirectory.path + "/" + identifier + ".jpg") {
            let imageURL = URL(fileURLWithPath: cachesDirectory.path).appendingPathComponent(identifier + ".jpg")
            let image = UIImage(contentsOfFile: imageURL.path)
            
            //print("Getting image from cache: " + imageURL.path)
            
            return image
        } else {
            //print("File not exist at: " + cachesDirectory.path + "/" + identifier + ".jpg")
            return nil
        }
    }
    
}


//
//  ImageSaving.swift
//  YBSFlickr
//
//  Created by S Browne on 31/07/2024.
//

import Foundation
import SwiftUI

/*
 Simple class for handling saving images to the Photo album.
 */

class ImageSaving: NSObject {
    
    static var shared = ImageSaving()
    
    func saveToPhotos(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved), nil)
    }
    
    @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Image saved.")
    }
}

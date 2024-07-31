//
//  Objects.swift
//  YBSFlickr
//
//  Created by S Browne on 31/07/2024.
//

import Foundation
import SwiftUI

struct Photo: Hashable {
    var json: PhotoJSON
    var infoJson: PhotoInfoJSON
    var image: UIImage
    var userProfilePicture: UIImage
}

enum ImageSize {
    case thumbnail
    case fullres
}

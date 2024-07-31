//
//  FlickrJSONTemplates.swift
//  YBSFlickr
//
//  Created by S Browne on 31/07/2024.
//

import Foundation
import SwiftUI

/*
 This file contains Codable object representations of the JSON received from Flickr, allowing the data to be used with ease throughout the code.
 */

struct PhotosSearchResponseJSON: Codable {
    var photos: PhotosJSON
}

struct PhotosJSON: Codable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: Int
    var photo: [PhotoJSON]
}

struct PhotoJSON: Codable, Hashable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var ispublic: Int
    var isfriend: Int
    var isfamily: Int
}

struct PhotoInfoTopLevelJSON: Codable, Hashable {
    var photo: PhotoInfoJSON
}

struct PhotoInfoJSON: Codable, Hashable {
    var id: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var dateuploaded: String?
    var isfavorite: Int?
    var license: String?
    var safety_level: String?
    var rotation: Int?
    var originalformat: String?
    var views: String?
    var media: String?
    var owner: PhotoInfoOwnerJSON?
    var tags: TagsJSON
    
}

struct PhotoInfoOwnerJSON: Codable, Hashable {
    var nsid: String?
    var username: String
    var realname: String?
    var location: String?
    var iconserver:String?
    var iconfarm: Int?
    var path_alias: String?
}
    
struct TagsJSON: Codable, Hashable {
    var tag: [TagJSON]
}

struct TagJSON: Codable, Hashable {
    var id: String
    var author: String
    var authorname: String
    var raw: String
}

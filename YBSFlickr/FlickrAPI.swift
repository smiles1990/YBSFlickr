//
//  FlickrAPI.swift
//  YBSFlickr
//
//  Created by S Browne on 31/07/2024.
//

import Foundation
import SwiftUI

/*
 FlickrAPI contains a number of functions that take parameters and construct API requests to Flickr, then decode the JSON returned into a Swift object structure to be returned.
 */

class FlickrAPI {
    
    static var shared = FlickrAPI()
    
    /*
     imageSearch takes Text, Tags and UserID parameters to use for a Flickr photo search.
    */
    func imageSearch(text: String, tags: [TagJSON], userId: String?) -> PhotosSearchResponseJSON? {
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "www.flickr.com"
        urlComponents.path = "/services/rest"
        
        var tagString = ""
        for tag in tags {
            tagString = tagString + tag.raw + ","
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: Constants.FlickrAPi.apiKey),
            URLQueryItem(name: "safe_search", value: "1"),
            URLQueryItem(name: "format", value: "json")
        ]
        
        if text != "" {
            urlComponents.queryItems?.append(URLQueryItem(name: "text", value: text))
        }
        
        if tags.count > 0 {
            urlComponents.queryItems?.append(URLQueryItem(name: "tags", value: tagString))
        }
        
        if userId != nil {
            urlComponents.queryItems?.append(URLQueryItem(name: "user_id", value: userId))
        }
        
        let url = URL(string: urlComponents.string!)
        
        let group = DispatchGroup()
        group.enter()
        
        var responseData: Data? = nil
        
        let task = URLSession.shared.dataTask(with: url!) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            responseData = data
            group.leave()
        }
        
        task.resume()
        
        group.wait()
        
        var decodedObject: PhotosSearchResponseJSON? = nil
        
        if responseData != nil {
            let jsonData = extractJson(data: responseData!)

            if let data = jsonData {
                decodedObject = decodeSearchJSON(data: data)
            }
        }

        return decodedObject
    }
    
    /*
     fetchImage takes a Photo object, downloads the Image from Flickr and returns it as a UIImage if possible.
    */
    func fetchImage(photoJSON: PhotoJSON, size: ImageSize) -> UIImage? {
     
        guard let imageURL = getImageURL(photoJson: photoJSON, size: size) else {
            print("Could not form URL")
            return nil
        }

        let group = DispatchGroup()
        group.enter()
        
        var responseData: Data? = nil
        let task = URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            responseData = data
            group.leave()
        }
        
        task.resume()
        group.wait()
        
        if let Image = UIImage(data: responseData!) {
            return Image
        } else {
            return nil
        }
        
    }
    
    /*
     getImageURL just constructs the url that the Image is stored at based on the info in the PhotoJSON.
     */
    func getImageURL(photoJson: PhotoJSON, size: ImageSize) -> URL? {
        
        let hostString = "https://live.staticflickr.com/"

        var sizeString = ""
        switch size{
        case .fullres:
            sizeString = "_b"
        case .thumbnail:
            sizeString = "_s"
        }
        
        let pathString = photoJson.server + "/" + photoJson.id + "_" + photoJson.secret + sizeString + ".jpg"
        let urlString = hostString + pathString
        
        return URL(string: urlString)
        
    }
    
    
    /*
     Constructs the URL for the user's profile picture, stored on Flickrs specific buddyicons service.
     */
    func fetchProfilePicture(photoJson: PhotoJSON ) -> UIImage? {
        
        let urlString = "https://farm" + String(photoJson.farm) + ".static.Flickr.com/" + photoJson.server
        let pathString = "/buddyicons/" + photoJson.owner + ".jpg"
        
        let fullRequestURLString = urlString + pathString
        let url = URL(string: fullRequestURLString)
        
        let group = DispatchGroup()
        group.enter()
        
        var responseData: Data? = nil
        let task = URLSession.shared.dataTask(with: url!) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            responseData = data
            group.leave()
        }
        
        task.resume()
        group.wait()
        
        if let Image = UIImage(data: responseData!) {
            return Image
        } else {
            return nil
        }
        
    }
    
    /*
     This function goes to the flickr.photos.getInfo endpoint for a given Photo and returns the JSON decoded into a Swift object structure.
     */
    func fetchPhotoInfo(photoID: String, secret: String) -> PhotoInfoTopLevelJSON? {
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "www.flickr.com"
        urlComponents.path = "/services/rest"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.getInfo"),
            URLQueryItem(name: "api_key", value: Constants.FlickrAPi.apiKey),
            URLQueryItem(name: "photo_id", value: photoID),
            URLQueryItem(name: "secret", value: secret),
            URLQueryItem(name: "format", value: "json")
        ]
        
        let url = URL(string: urlComponents.string!)
        
        let group = DispatchGroup()
        group.enter()
        
        var responseData: Data? = nil
        
        let task = URLSession.shared.dataTask(with: url!) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            responseData = data
            group.leave()
        }
        
        task.resume()
        
        group.wait()
        
        var decodedObject: PhotoInfoTopLevelJSON? = nil
        
        if responseData != nil {
            let jsonData = extractJson(data: responseData!)

            if let data = jsonData {
                decodedObject = decodePhotoInfoJSON(data: data)
            }
        }
        
        return decodedObject
        
    }
    
    /*
     extractJson just performs the task of removing the 'jsonFlickrApi({})' top level wrapper so the json can be decoded using Swift's JSONDecoder.
     */
    func extractJson(data: Data) -> Data? {
        guard let jsonString = String(data: data, encoding: .utf8) else {
            print("Could not convert data to string")
            return nil
        }
        let prefix = "jsonFlickrApi("
        let suffix = ")"

        let startIndex = jsonString.index(jsonString.startIndex, offsetBy: prefix.count)
        let endIndex = jsonString.index(jsonString.endIndex, offsetBy: -suffix.count)
            
        let jsonSegment = jsonString[startIndex..<endIndex]
            
        guard let jsonData = jsonSegment.data(using: .utf8) else {
            print("Could not convert JSON  to data")
            return nil
        }
            
        return jsonData
    }
    
    
    /*
     decodes data from a flickr.photos.getinfo call into Swift object.
     */
    func decodePhotoInfoJSON(data: Data) -> PhotoInfoTopLevelJSON? {
        do {
            let decodedJSON = try JSONDecoder().decode(PhotoInfoTopLevelJSON.self, from: data)
            return decodedJSON
        } catch {
            print(error)
            print("Failed to decode PhotoInfo JSON.")
            return nil
        }
    }
    
    /*
     decodes data from a flickr.photos.search call into Swift object.
     */
    func decodeSearchJSON(data: Data) -> PhotosSearchResponseJSON? {
        do {
            let decodedJSON = try JSONDecoder().decode(PhotosSearchResponseJSON.self, from: data)
            return decodedJSON
        } catch {
            print(error)
            print("Failed to decode Search JSON.")
            return nil
        }
    }
    
    
}

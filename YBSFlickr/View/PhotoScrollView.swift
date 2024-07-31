//
//  PhotoScrollView.swift
//  YBSFlickr
//
//  Created by S Browne on 31/07/2024.
//

import Foundation
import SwiftUI

/*
 -PhotoScrollView is the class where the navigationstack and main photo stream are managed.
 -ScrollView contains a grid of PhotoCell Objects which contain all the photos data.
 */
struct PhotoScrollView: View {
    
    @State var foundImages: [Photo] = []
    @State var searchText = ""
    @State var currentTags: [TagJSON] = []
    
    @State var populated: Bool = false
    
    var gridColumns = [GridItem(.fixed(UIScreen.main.bounds.width), spacing: 0)]
    
    var body: some View {
        VStack(alignment: .center) {
            NavigationStack {
                Constants.ColorSet.defaultGreen
                    .ignoresSafeArea()
                    .frame(height: 0)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                ZStack(alignment: .topLeading) {
                    VStack(spacing: 0){
                        ScrollView {
                            LazyVGrid(columns: gridColumns){
                                ForEach(foundImages, id: \.self) { obj in
                                    PhotoCell(photo: obj, parentView: self)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8))
                                }
                            }
                        }
                        .background(.white)
                        .onAppear {
                            if populated == false {
                                populated = true
                                searchAndFetch(text:"Yorkshire", tags: [], userId: nil)
                            }
                        }
                    }
                    VStack(spacing: 0){
                        PhotoSearchView(parentView: self)
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                }
                .navigationTitle(searchText)
                .navigationBarTitleDisplayMode(.inline)
            }
            .tint(.black)
            
        }
    }
    
    /*
    This function is called from different subviews to carry out a new search.
     It facilitates constructing a request containing any combination of Text/Tags/UserId.
     Currently the UI doesn't allow combining these different parameters, any call in this version provides one of the possible parameters only.
     */
    func searchAndFetch(text: String, tags: [TagJSON], userId: String?) {
        currentTags.append(contentsOf: tags)
        
        var searchDescString = text
        
        if tags.count > 0 {
            var tagsString = "Tags("
            for tag in tags {
                tagsString = tagsString + "\(tag.raw), "
            }
            tagsString.removeLast(2)
            tagsString = tagsString + ")"
            searchDescString = searchDescString + tagsString
        } else if userId != nil {
            searchDescString = searchDescString + "UserID(" + userId! + ")"
        }
        
        searchText = searchDescString
        foundImages = []
        
        /*
         Currently the function will attempt to fetch all associated data for a Photo beforing adding it as a result to be displayed.
         For now, if any part of the data cannot be fetched and decoded for whatever reason, the entry will be ignored.
         */
        if let response = FlickrAPI.shared.imageSearch(text: text, tags: tags, userId: userId) {
            for photoJson in response.photos.photo {
                Task {
                    
                    guard let image = FlickrAPI.shared.fetchImage(photoJSON: photoJson, size: .fullres) else {
                        return
                    }
                    guard let profilePicture = FlickrAPI.shared.fetchProfilePicture(photoJson: photoJson) else {
                        return
                    }
                    
                    guard let photoInfo = FlickrAPI.shared.fetchPhotoInfo(photoID: photoJson.id, secret: photoJson.secret) else {
                        return
                    }
                            
                    let obj = Photo(json: photoJson, infoJson: photoInfo.photo, image: image, userProfilePicture: profilePicture)
                    
                    foundImages.append(obj)
                    
                }
                
            }
        }
    }
    
    /*
     This function helps determine the size of the TagCollectionView based on the number of tags that need to be shown
     -Ideally this function should be contained within the TagCollectionView code or someone more generic than here.
     */
    func calculateTagCollectionViewHeight(numberOfTags: Int) -> CGFloat {
        var rows = 0
        if numberOfTags == 0 {
            rows = 0
        } else if (numberOfTags % 4) == 0 {
            rows = (numberOfTags / 4)
        } else {
            rows = (numberOfTags / 4) + 1
        }
        
        let height: CGFloat = CGFloat((20 * rows) + 8)
        
        return height
    }
    
}

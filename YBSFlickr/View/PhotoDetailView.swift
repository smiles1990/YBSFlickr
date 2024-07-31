//
//  PhotoDetailView.swift
//  YBSFlickr
//
//  Created by S Browne on 31/07/2024.
//

import Foundation
import SwiftUI

/*
 -PhotoDetailView is the detail view that presents when an PhotoCell's image is pressed.
 -This view contains the owner's name and profile picture, a list of tags, the number of view the image has receceived, the date taken.
 -There is also a button that saved the image to the users photos app, this will trigger a permission overlay on first attempt.
 */
struct PhotoDetailView: View {
    
    @State var photo: Photo
    @State var imageSaveAttempt = false
    
    let dateFormatter = DateFormatter()
    
    let parentView: PhotoScrollView
    
    init(photo: Photo, parentView: PhotoScrollView) {
        self.photo = photo
        self.dateFormatter.dateStyle = .medium
        self.parentView = parentView
    }
    
    var body: some View {
        Constants.ColorSet.defaultGreen
            .ignoresSafeArea()
            .frame(height: 0)
        VStack(alignment: .center, spacing: 8) {
            Image(uiImage: photo.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: UIScreen.main.bounds.width - 32, maxHeight: UIScreen.main.bounds.width - 32)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
                .clipped()
            VStack(alignment: .leading) {
                HStack{
                    HStack{
                        Image(uiImage: photo.userProfilePicture)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 0))
                        Text(photo.infoJson.owner?.username ?? "unknown")
                            .foregroundStyle(.black)
                            .frame(height: 32)
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    }
                    .onTapGesture {
                        parentView.searchAndFetch(text: "", tags: [], userId: photo.json.owner)
                    }
                    Spacer()
                    VStack(alignment: .trailing){
                        Text("Uploaded:")
                            .font(.footnote)
                        if let timeInterval = Double(photo.infoJson.dateuploaded!) {
                            let date = Date(timeIntervalSince1970: timeInterval)
                            Text(dateFormatter.string(from: date))
                        }
                    }
                    .padding()
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("Views: " + photo.infoJson.views!)
                            .font(.subheadline)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 0))
                        Text("Tags:")
                            .font(.subheadline)
                    }
                    Spacer()
                    Button {
                        if imageSaveAttempt == false {
                            ImageSaving.shared.saveToPhotos(image: photo.image)
                            imageSaveAttempt = true
                        }
                        
                    } label: {
                        ZStack{
                            Image(systemName: "square.and.arrow.down")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .foregroundStyle(Constants.ColorSet.defaultGreen)
                                .frame(width: 32, height: 32)
                                .padding()
                                .opacity(imageSaveAttempt ? 0.2 : 1)
                            Image(systemName: "checkmark")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .foregroundStyle(Constants.ColorSet.defaultGreen)
                                .frame(width: 32, height: 32)
                                .padding()
                                .opacity(imageSaveAttempt ? 1 : 0)
                        }
                    }
                    
                }
                
                ScrollView {
                    TagCollectionView(tagArray: photo.infoJson.tags.tag, parentView: parentView)
                        .frame(width: UIScreen.main.bounds.width - 32, height: parentView.calculateTagCollectionViewHeight(numberOfTags: photo.infoJson.tags.tag.count))
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .scaledToFill()
            }
            .padding()
            
        }
        .navigationTitle(photo.json.title)
        .font(.title3)
    }
    
}

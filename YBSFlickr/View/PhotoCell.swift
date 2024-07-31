//
//  PhotoCell.swift
//  YBSFlickr
//
//  Created by S Browne on 31/07/2024.
//

import Foundation
import SwiftUI

/*
 -PhotoCell objects contain the Photo object representing the information relevant to the entry.
 -Also displays the image, a collapsable list of tags, the owners Name and profile picture.
 -If the Photo Owner's profile picture or name are pressed, the cell will trigger a new search for images from that User.
 */
struct PhotoCell: View {
    
    var photo: Photo
    
    @State private var showTags = false
    @State var iconName = "tag.circle.fill"
    
    var parentView: PhotoScrollView
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                Image(uiImage: photo.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width-16, height: UIScreen.main.bounds.width-16)
                NavigationLink(destination: PhotoDetailView(photo: photo, parentView: parentView)) {
                    Rectangle()
                        .opacity(0.0)
                }

                HStack(alignment: .bottom) {
                    HStack {
                        Image(uiImage: photo.userProfilePicture)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 0))
                        Text(photo.infoJson.owner?.username ?? "unknown")
                            .foregroundStyle(.white)
                            .frame(height: 32)
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    }
                    .onTapGesture {
                        parentView.searchAndFetch(text: "", tags: [], userId: photo.json.owner)
                    }
                    Spacer()
                    Image(systemName: iconName)
                        .font(.title)
                        .foregroundStyle(.white, Constants.ColorSet.defaultGreen)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .onTapGesture {
                            toggleTagsView()
                        }
                }
                .background(LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .top))
                
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            TagCollectionView(tagArray: photo.infoJson.tags.tag, parentView: parentView)
                .frame(height: showTags ? parentView.calculateTagCollectionViewHeight(numberOfTags: photo.infoJson.tags.tag.count) : 0)
                .opacity(showTags ? 1 : 0)
                .background(.black)
        }
    }
    
    //This function just manages expanding and collapsing the TagCollectionView.
    func toggleTagsView() {
        withAnimation(.easeIn){
            showTags.toggle()
        }
        if showTags == false {
            iconName = "tag.circle.fill"
        } else if showTags == true {
            iconName = "xmark.circle.fill"
        }
    }
    
    
    
}

//
//  TagCollectionView.swift
//  YBSFlickr
//
//  Created by S Browne on 31/07/2024.
//

import Foundation
import SwiftUI

/*
 -TagCollectionView is used by PhotoCell and PhotoDetail to display a list of tags associated with an a Photo.
 -Contains a grid of TagCollectionViewItems each representing a tag, these views trigger a search for that tag when pressed.
 */
struct TagCollectionView: View {
    
    @State var tagArray: [TagJSON]
    let columns = [GridItem(), GridItem(), GridItem(), GridItem()]
    
    let parentView: PhotoScrollView
    
    init(tagArray: [TagJSON], parentView: PhotoScrollView) {
        self.tagArray = tagArray
        self.parentView = parentView
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 4){
            ForEach(tagArray, id: \.self) { obj in
                TagCollectionViewItem(tag: obj)
                    .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 0))
                    .onTapGesture {
                        parentView.searchAndFetch(text: "", tags: [obj], userId: nil)
                    }
            }
        }
    }
    
}

struct TagCollectionViewItem: View {
    
    var tag: TagJSON
    var frameWidth = ((UIScreen.main.bounds.width - 64) / 4)
    
    init(tag: TagJSON) {
        self.tag = tag
    }
    
    var body: some View {
        ZStack() {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Constants.ColorSet.defaultGreen)
                .frame(width: frameWidth, height: 16)
            Text(tag.raw.capitalized)
                .foregroundStyle(.white)
                .font(.subheadline).scaledToFit()
        }
        .frame(width: frameWidth, height: 16)
        
    }
}

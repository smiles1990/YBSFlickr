//
//  ContentView.swift
//  YBSFlickr
//
//  Created by S Browne on 31/07/2024.
//

import SwiftUI

/*
 -PhotoScrollView is the class where the navigationstack and main photo stream are managed.
 -PhotoSearchView is a custom overlay added to handle the searchbar and keyboard.
 -PhotoCell objects contain the Photo object representing the information relevant to the entry.
 -PhotoDetailView is the detail view that presents when an PhotoCell's image is pressed.
 -TagCollectionView is used by PhotoCell and PhotoDetail to display a list of tags associated with an a Photo.
 */
struct ContentView: View {
    var body: some View {
        PhotoScrollView()
    }
}

#Preview {
    ContentView()
}

//
//  PhotoSearchView.swift
//  YBSFlickr
//
//  Created by S Browne on 31/07/2024.
//

import Foundation
import SwiftUI

/*
 -PhotoSearchView is a custom overlay added to handle the searchbar and keyboard.
 */

struct PhotoSearchView: View {
    
    @State private var showSearchBar = false
    @State private var userInput = ""
    @State var imageName = "magnifyingglass.circle.fill"
    @FocusState private var searchIsFocused: Bool
    @State var hideProgressView = true
    
    var parentView: PhotoScrollView
    var viewTint = Constants.ColorSet.defaultGreen
    
    init(parentView: PhotoScrollView) {
        self.parentView = parentView
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                ZStack(alignment: .top){
                    ZStack{
                        searchBarBackground
                        TextField("What do you want to see?", text: $userInput)
                            .textFieldStyle(PlainTextFieldStyle())
                            .disableAutocorrection(true)
                            .font(.body.weight(.semibold))
                            .focused($searchIsFocused)
                            .submitLabel(.search)
                            .onSubmit {
                                forwardNewSearch(text: userInput)
                                userInput = ""
                                toggleSearchOverlay()
                            }
                            .onAppear {
                                UITextField.appearance().clearButtonMode = .whileEditing
                            }
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    }
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
            }
            .frame(height: showSearchBar ? nil : 0)
            .opacity(showSearchBar ? 1 : 0)
            
            ZStack{
                Image(systemName: imageName)
                    .font(.title)
                    .foregroundStyle(.white, viewTint)
                    .onTapGesture {
                        toggleSearchOverlay()
                    }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    
    var searchBarBackground: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white)
                .frame(height: 30.0)
            RoundedRectangle(cornerRadius: 4)
                .stroke(viewTint, lineWidth: 4.0)
                .frame(height: 30.0)

        }
    
    }

    func forwardNewSearch(text: String) {
        parentView.searchAndFetch(text: text, tags: [], userId: nil)
    }
    
    //This function just manages expanding and collapsing the SearchBar.
    func toggleSearchOverlay() {
        withAnimation(.easeIn){
            showSearchBar.toggle()
            searchIsFocused.toggle()
        }
        if showSearchBar == false {
            imageName = "magnifyingglass.circle.fill"
        } else if showSearchBar == true {
            imageName = "chevron.up.circle.fill"
        }
    }
    
    
    
}

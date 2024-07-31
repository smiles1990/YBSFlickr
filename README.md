# Overview:

-**YBSFlickr** is my attempt at the outlined spec for the YBS Technical Test. 

-The application allows users to search for and present photos from Flickr, providing various features to enhance the user experience.


![Screenshot 2024-07-31 at 23 15 02](https://github.com/user-attachments/assets/23bc2727-bd08-441f-94e7-71cda6983cc0)
![Screenshot 2024-07-31 at 23 15 52](https://github.com/user-attachments/assets/b290d0d9-20bd-4f63-83ac-1372b721c97c)



# Approach:

-To start with I outlined the necessary functionality from the spec provided

-I madea a brief plan of different classes I would need to write and their responsabilities.

-I aimed to implement all necessary functionality and more, whilst trying to keep the app looking clean, responsive and intuitive.




# Features:

**-Search Functionality:** Users can type in a search term to find photos from Flickr.

**-Image Display:** Images are displayed along with owner information and tags.

**-Detailed View:** Selecting an image presents detailed information about the photo.

**-Save Photos:** Users can save photos to their device's Photos app.

**-User Search:** Selecting a username or profile picture triggers a search for photos submitted by that user.

**-Tag Search:** Selecting a tag triggers a search for that specific tag.




# Known-issues:

-Tags button within PhotoCell sometimes doesn’t respond to .onTapGesture.

-Some unwanted layout issues in PhotoDetailView when the number of tags is very high.




# Future Improvements:

-Introduce more robust error handling.

-Fix minor/edge-case graphical issues.

-Incorporate paging back from detail view when tag or user search is initiated from a detail view.

-Improve how TabCollectionView arranges tags, to make better use of space based on the length of the tag strings.

-Add functionality in the UI for managing and searching with multiple tags.

-Add better tools for viewing or editing high-resolution images.

-Implement search pagination to handle large sets of search results.

-Add image caching as per Flickr API terms of use for live apps.

-Implement user authentication and features for uploading and managing images.




# Dependencies:

-I’ve not used any third party libraries for this project,  I try to avoid adding dependencies to a project unless necessary. I am however familiar with using cocoapods to manage app dependencies when they are needed.

# DoloExcercise

This project is a coding excercise for the company Dolo.

To run the project simply clone the repo and run on Xcode. It is recommended to use a coordinate location somewhere in San Francisco when running the project in Xcode as Apple Headquarters location is used by Foursquare API for testing resulting in garbage locations

Design Decisions:

-MVVM architecture

-No third party frameworks were used to keep the project as robust as possible

-Protocol oriented networking calls

-Codeable model using new Swift 4 JSONDecode

-Delegates/protocols for communication pattern

-Dynamic height header textview up to three lines then scroll functionality for both header and body textview

-Core location used for user current location

-UIImagePicker to get photos from photo library/camera

-Photos added to the end of body textview using NSAttributedString attachment

-Custom search bar and search functionality

-Extensions used to build URLs

-Extension for icon image API calls

-All colors and fonts are per Zeplin specs

-Optimized for all iPhone screen sizes

-Unit testing for URL creation as well as successful API calls with the correct payload


# UIImageView-AsyncLoad
=======================

UIImageView+AsyncLoad is an extension of UIImageView for loading and displaying images asynchronously on iOS. Developer will have a hassle free environment for showing the remote image on imageview without doing much work, more sepcifically not worring about network calls, with out blocking the UI.

![solarized vim](https://i.imgsafe.org/19b15a9dea.jpg)


Installation
=======================

To use the UIImageView+AsyncLoad in an app, just drag the `ImageDownloadManager.swift` & `UIImageView+AsyncLoad.swift`  files into your project.


Usage 
=======================

Use the  APi `setImageFrom(imageURLString : String, placeHolderImage: UIImage = UIImage(), completionBlock: DownloadHandler?)` on the UIImageView instance, pass the remote image URL to be displayed, check the below snippet for example.

![solarized vim](http://i.imgur.com/bhdIa0H.png)

And "Thats it" 

*Note : Additonaly if you want to pass the placeholder image, just add an argument `placeHolderImage` and pass the image, rest is taken care.


# printful-assignment

Hello, Printful!

This app has done this assignement:

Create an iOS application that allows the user to browse Printful catalog:
show available categories
browse products in a selected category
show product details
support user to favorite product
provide a way to see all favorite products in a list
We would like to see the project done using SwiftUI, structured concurrency and modularization.
API
Please use the Printful API to load all necessary data: https://developers.printful.com/docs/ 

Some key points:
* App does not use 3rd party frameworks so it should be easy "plug-n-play" to run the app.
* This app heavely tries to use caches to improve user experience in preformance wise.
* App is based on Core Data so when data are downloaded they are stored in local db but app is using those data. In this way data can be pre-fetched and all views can be up to date with data without needed to pass it. Some specific filters or sorting are done in CoreData as it's the fastest way and also keeps "ugly" back logic away from view layers.
* App architecture is based on idea View-ViewModel-Interactor-Repository. In this way ViewModel never tries to access Repository directly.
* App reacts on Errors catcing Printful API errors with messages as tey come from backend as well as local issues like loss of network.
* Categories grid is very simmilar to the origianal Printful app.
* Views support Pull to refresh were applicible.
* View Componnets are not that resuable as they could be I would need to work more on that. Although you can see that Favorites and Products Views are made in very reusable way.


Well there are many parts to be improved the goal is just to show preview of my style but keep in mind that this is made in some limited time so dont look for absolut prefection there.

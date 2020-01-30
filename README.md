# Assignment

Language: Swift 5

XCode Version: 11.3.1

Architectural Design Pattern: MVVM

Third Party SDK Used: [web3Swift](https://github.com/matter-labs/web3swift "web3Swift")

Ethereum Private Key For Testing: CF02C73D0BDBFD92864D51F8F2238919AB29CE5612CCCBADC2FE6DF8D1ACAAAE

## Details

In this project, I've completed all the required functionalities for the App as per the specification document. The communication with Ethereum Rinkeby network is done using web3Swift SDK and Infura API. 

## Architecture

I've followed MVVM architectural design pattern and have separate Groups/Folders for Views, Models & ViewModels. All the ViewControllers are present inside View Group, ViewModels are present in ViewModel group. I have also created 1 model class named Waller to save the user's Adress, Private Key & Balance. All the UI components are present inside View and Business logic is present inside ViewModels.

## UI

To design layouts & UI I've used Storyboard. I have also used SplitViewController to support both Portrait and Landscape Orientations.

## QR Code Scanning Functionality

For QR Code Scanning I've implemented my own functionality using Apple's AVFoundation Package. I didn't use any third-party library for this purpose.

## Testing

I have also written unit tests for my ViewModels.

## Screenshots

<img src="https://github.com/asad175/Assignment/blob/master/screenshots/IMG_1818.jpg" width="300"><img src="https://github.com/asad175/Assignment/blob/master/screenshots/IMG_1819.jpg" width="300"><img src="https://github.com/asad175/Assignment/blob/master/screenshots/IMG_1820.jpg" width="300"><img src="https://github.com/asad175/Assignment/blob/master/screenshots/IMG_1821.jpg" width="300"><img src="https://github.com/asad175/Assignment/blob/master/screenshots/IMG_1822.jpg" width="300">

## Landscape

<img src="https://github.com/asad175/Assignment/blob/master/screenshots/IMG_1823.jpg" width="700">

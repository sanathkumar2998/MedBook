# MedBook

MedBook is an application to search for books, and sort them based on title, ratings or hits.

## Getting Started

### Requirements

* iOS 16.0+
* Swift 5.0+

### Dependencies

* Kingfisher - Used for downloading and caching the cover image of a book.
* Link to Kingfisher repo - https://github.com/onevcat/Kingfisher

## Details

### Archictecture

* Clean Swift with VIP cycle
* I would like to highlight a couple of reasons for choosing VIP over MVVM
  * The VM in MVVM has a habit of becoming huge, as it is responsible for all the business logic and the presentation logic. This makes the VM harder to scale and manage.
  * The VM can also become harder to test due to it's growing size. This also results in our test files becoming large and harder to manage.
* In the VIP cycle, the components are View, Interactor and Presenter. These components are highly decoupled and the flow of communication is unidirectional. These features make them easier to scale, manage and test.

### Local Database

* Core Data

### Learnings

* I had not worked on Search+Pagination feature before (had worked on them separately). This was a learning scenario for me.

### Improvements

* Could store the password in a more secure manner, by storing it in Keychain.
* Could handle some of the edge cases related to Core Data.

### Notes

* I have implemented up till Level 2. I could not get to Level 3 due to lack of time. Apologies.
* I have used Kingfisher framework for loading the cover images. Initally, I wanted to implement an imageCache for it, but ran out of time.

## Authors

Sanathkumar M S
* Email: sanathkumar2998@gmail.com



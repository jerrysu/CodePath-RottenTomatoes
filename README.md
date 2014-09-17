## CodePath, Week 1 Project: Rotten Tomatoes

This is a simple Rotten Tomatoes client written in Swift that uses the [RottenTomatoes API](http://developer.rottentomatoes.com/). It uses various UIKit components as well as some CocoaPods to display a list of movies and individual film details.

**Time spent**: Approximately 12 hours total

It took several attempts (and more than half of the total time spent) to add the tab bar as I couldn't find a way to reuse the views. The end result was the cleanest solution that I could find, which involved reuse of the views through storyboard using an extra container view.

### Walkthrough

![Walkthrough](RottenTomatoes.gif)

### Requirements

The checked items below were completed.

 * [x] User can view a list of movies from Rotten Tomatoes. Poster images must be loading asynchronously.
 * [x] User can view movie details by tapping on a cell
 * [x] User sees loading state while waiting for movies API. You can use one of the 3rd party libraries at cocoacontrols.com.
 * [x] User sees error message when there's a networking error. You may not use UIAlertView to display the error. See this screenshot for what the error message should look like: network error screenshot.
 * [x] User can pull to refresh the movie list.
 * [x] All images fade in (optional)
 * [x] For the large poster, load the low-res image first, switch to high-res when complete (optional)
 * [x] All images should be cached in memory and disk. In other words, images load immediately upon cold start (optional).
 * [x] Customize the highlight and selection effect of the cell. (optional)
 * [x] Customize the navigation bar. (optional)
 * [x] Add a tab bar for Box Office and DVD. (optional)
 * [ ] Add a search bar. (optional)

### Installation

Run the following in command-line:

```
pod install
open RottenTomatoes.xcworkspace
```

In XCode 6, run the app using the `iPhone 5S` simulator.

### Resources

The following CocoaPods were used:

 * [AFNetworking](https://github.com/AFNetworking/AFNetworking)
 * [SVProgressHUD](https://github.com/samvermette/SVProgressHUD)
 * [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh)
 * [TSMessages](https://github.com/toursprung/TSMessages)
 * [TTTAttributedLabel](https://github.com/mattt/TTTAttributedLabel)

### License

> The MIT License (MIT)
>
> Copyright © 2014 Jerry Su, http://jerrysu.me
>
> Permission is hereby granted, free of charge, to any person obtaining a copy of
> this software and associated documentation files (the “Software”), to deal in
> the Software without restriction, including without limitation the rights to
> use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
> the Software, and to permit persons to whom the Software is furnished to do so,
> subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
> FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
> COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
> IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

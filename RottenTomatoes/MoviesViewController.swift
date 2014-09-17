//
//  ViewController.swift
//  RottenTomatoes
//
//  Created by Jerry Su on 9/13/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var movieTableView: UITableView!

    var moviesArray: NSArray = []
    var mode: MoviesViewMode = .BoxOffice

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fix an issue with the separator inset in iOS8
        if (movieTableView.respondsToSelector(Selector("layoutMargins"))) {
            movieTableView.layoutMargins = UIEdgeInsetsZero;
        }

        movieTableView.backgroundColor = .blackColor()
        movieTableView.tintColor = .whiteColor()

        SVProgressHUD.show()
        loadMovies()
    }

    override func viewDidAppear(animated: Bool) {
        movieTableView.addPullToRefreshWithActionHandler(loadMovies)
        movieTableView.pullToRefreshView.activityIndicatorViewStyle = .White
    }

    func loadMovies() {
        let request = NSMutableURLRequest(URL: getEndpointURL())
        request.timeoutInterval = NSTimeInterval(10)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            SVProgressHUD.dismiss()

            if (self.movieTableView.pullToRefreshView != nil) {
                self.movieTableView.pullToRefreshView.stopAnimating()
            }

            TSMessage.dismissActiveNotification()

            var errorValue: NSError?
            if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as? NSDictionary {
                self.moviesArray = dictionary["movies"] as NSArray
                self.movieTableView.reloadData()
            } else {
                TSMessage.showNotificationWithTitle(
                    "Network error",
                    subtitle: "Couldn't connect to the server. Check your network connection.",
                    type: .Error
                )
            }
        })
    }

    func getEndpointURL() -> NSURL {
        switch mode {
            case .TopRentals:
                return RottenTomatoesApi.getEndpointURL(.TopRentals)
            default:
                return RottenTomatoesApi.getEndpointURL(.BoxOffice)
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCellWithIdentifier("MovieTableViewCell") as MovieTableViewCell

        let movie = Movie(dictionary: moviesArray[indexPath.row] as NSDictionary)

        cell.titleLabel.text = movie.title

        cell.descriptionLabel.setText("\(movie.mpaaRating) \(movie.synopsis)", afterInheritingLabelAttributesAndConfiguringWithBlock: { (mutableAttributedString: NSMutableAttributedString!) -> NSMutableAttributedString! in
                let boldFont = UIFont.boldSystemFontOfSize(cell.descriptionLabel.font.pointSize)
                // TODO: Clean this up...
                mutableAttributedString.addAttribute(kCTFontAttributeName as NSString, value: boldFont, range: NSRange(location: 0, length: movie.mpaaRating.length))
                return mutableAttributedString
            })

        let request = NSURLRequest(URL: movie.thumbnailURL)
        let cachedImage = UIImageView.sharedImageCache().cachedImageForRequest(request)
        if (cachedImage != nil) {
            cell.thumbnailImage.image = cachedImage
        } else {
            // Fade in the image after it is loaded
            cell.thumbnailImage.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) in
                cell.thumbnailImage.alpha = 0.0
                cell.thumbnailImage.image = image
                UIView.animateWithDuration(1.0, animations: {
                    cell.thumbnailImage.alpha = 1.0
                })
                }, failure: nil)
        }

        // Fix an issue with the separator inset in iOS8
        if (cell.respondsToSelector(Selector("layoutMargins"))) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "details" {
            let controller = segue.destinationViewController as MovieDetailsViewController
            let indexPath = movieTableView.indexPathForSelectedRow()!
            controller.movie = Movie(dictionary: moviesArray[indexPath.row] as NSDictionary)
        }
    }

}

enum MoviesViewMode {
    case BoxOffice, TopRentals
}


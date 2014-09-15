//
//  ViewController.swift
//  RottenTomatoes
//
//  Created by Jerry Su on 9/13/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var movieTableView: UITableView!

    var moviesArray: NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.show()
        loadMovies()
    }

    override func viewDidAppear(animated: Bool) {
        movieTableView.addPullToRefreshWithActionHandler(loadMovies)
        movieTableView.pullToRefreshView.activityIndicatorViewStyle = .White
    }

    func loadMovies() {
        self.movieTableView.backgroundColor = UIColor.blackColor()
        self.movieTableView.tintColor = UIColor.whiteColor()

        let RottenTomatoesApiKey = "yz8aght3p6b47r22wmkyezan"
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=50&apikey=" + RottenTomatoesApiKey
        let request = NSMutableURLRequest(URL: NSURL.URLWithString(RottenTomatoesURLString))
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if moviesArray != nil {
            return moviesArray!.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCellWithIdentifier("com.codepath.rottentomatoes.moviecell") as MovieTableViewCell

        let movieDictionary = self.moviesArray![indexPath.row] as NSDictionary

        cell.titleLabel.text = movieDictionary["title"] as NSString

        let rating = movieDictionary["mpaa_rating"] as NSString
        let synopsis = movieDictionary["synopsis"] as NSString
        cell.descriptionLabel.setText("\(rating) \(synopsis)", afterInheritingLabelAttributesAndConfiguringWithBlock: { (mutableAttributedString: NSMutableAttributedString!) -> NSMutableAttributedString! in
                let boldFont = UIFont.boldSystemFontOfSize(cell.descriptionLabel.font.pointSize)
                // TODO: Clean this up...
                mutableAttributedString.addAttribute(kCTFontAttributeName as NSString, value: boldFont, range: NSRange(location: 0, length: rating.length))
                return mutableAttributedString
            })

        let posters = movieDictionary["posters"] as NSDictionary
        let thumbnail = (posters["profile"] as NSString).stringByReplacingOccurrencesOfString("tmb", withString: "pro")
        let thumbnailURL = NSURL(string: thumbnail)
        let request = NSURLRequest(URL: thumbnailURL)
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

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "details" {
            let controller = segue.destinationViewController as MovieDetailsViewController
            let indexPath = movieTableView.indexPathForSelectedRow()!
            controller.movieDictionary = self.moviesArray![indexPath.row] as? NSDictionary
        }
    }

}


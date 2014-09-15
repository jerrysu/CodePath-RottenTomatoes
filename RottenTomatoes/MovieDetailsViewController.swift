//
//  MovieDetailsViewController.swift
//  RottenTomatoes
//
//  Created by Jerry Su on 9/13/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!

    var movieDictionary: NSDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()

        let title = movieDictionary!["title"] as NSString
        self.navigationItem.title = title

        let year = movieDictionary!["year"] as NSNumber
        titleLabel.text = "\(title) (\(year))"

        let posters = movieDictionary!["posters"] as NSDictionary
        let original = (posters["original"] as NSString).stringByReplacingOccurrencesOfString("tmb", withString: "ori")
        let originalURL = NSURL(string: original)
        let request = NSURLRequest(URL: originalURL)
        let cachedImage = UIImageView.sharedImageCache().cachedImageForRequest(request)
        if (cachedImage != nil) {
            backgroundImage.image = cachedImage
        } else {
            // Use the thumbnail image as a placeholder
            let thumbnail = (posters["profile"] as NSString).stringByReplacingOccurrencesOfString("tmb", withString: "pro")
            let thumbnailURL = NSURL(string: thumbnail)
            backgroundImage.setImageWithURL(thumbnailURL)

            // Fade in the image after it is loaded
            backgroundImage.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) in
                self.backgroundImage.image = image
            }, failure: nil)
        }

        let scores = movieDictionary!["ratings"] as NSDictionary
        let critics_score = scores["critics_score"] as NSNumber
        let audience_score = scores["audience_score"] as NSNumber
        scoreLabel.text = "Critics Score: \(critics_score), Audience Score: \(audience_score)"

        let rating = movieDictionary!["mpaa_rating"] as NSString
        ratingLabel.text = rating

        let synopsis = movieDictionary!["synopsis"] as NSString
        synopsisLabel.text = synopsis
        synopsisLabel.sizeToFit()

        let screenSize: CGRect = UIScreen.mainScreen().bounds

        // Resize the UIView to fit the contents
        var frame = contentView.frame
        var height = max(frame.size.height, synopsisLabel.frame.origin.y + synopsisLabel.bounds.height + 20);
        frame.size.height = height + screenSize.height
        contentView.frame = frame

        // Set the content size of the UIScrolLView
        scrollView.contentSize = CGSizeMake(screenSize.width, frame.origin.y + height)
    }

}

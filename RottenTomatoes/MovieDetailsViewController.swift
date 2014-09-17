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

    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = movie!.title

        titleLabel.text = "\(movie!.title) (\(movie!.year))"

        let request = NSURLRequest(URL: movie!.posterURL)
        let cachedImage = UIImageView.sharedImageCache().cachedImageForRequest(request)
        if (cachedImage != nil) {
            backgroundImage.image = cachedImage
        } else {
            // Use the thumbnail image as a placeholder
            backgroundImage.setImageWithURL(movie!.thumbnailURL)

            // Fade in the image after it is loaded
            backgroundImage.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) in
                self.backgroundImage.image = image
            }, failure: nil)
        }

        scoreLabel.text = "Critics Score: \(movie!.criticsScore), Audience Score: \(movie!.audienceScore)"
        ratingLabel.text = movie!.mpaaRating
        synopsisLabel.text = movie!.synopsis
        synopsisLabel.sizeToFit()

        let screenSize: CGRect = UIScreen.mainScreen().bounds

        // Resize the UIView to fit the contents
        var frame = contentView.frame
        var height = max(frame.size.height, synopsisLabel.frame.origin.y + synopsisLabel.bounds.height + 20) + tabBarController!.tabBar.frame.height;
        frame.size.height = height + screenSize.height
        contentView.frame = frame

        // Set the content size of the UIScrolLView
        scrollView.contentSize = CGSizeMake(screenSize.width, frame.origin.y + height)
    }

}

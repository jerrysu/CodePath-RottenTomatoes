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

        self.movieTableView.backgroundColor = UIColor.blackColor()
        self.movieTableView.tintColor = UIColor.whiteColor()

        let RottenTomatoesApiKey = "yz8aght3p6b47r22wmkyezan"
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=50&apikey=" + RottenTomatoesApiKey
        let request = NSMutableURLRequest(URL: NSURL.URLWithString(RottenTomatoesURLString))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = nil
            let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
            self.moviesArray = dictionary["movies"] as? NSArray
            self.movieTableView.reloadData()
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
        let thumbnail = (posters["thumbnail"] as NSString).stringByReplacingOccurrencesOfString("tmb", withString: "ori")
        cell.thumbnailImage.setImageWithURL(NSURL(string: thumbnail))

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


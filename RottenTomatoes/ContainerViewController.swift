//
//  ContainerViewController.swift
//  RottenTomatoes
//
//  Created by Jerry Su on 9/16/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let moviesViewController = segue.destinationViewController as MoviesViewController
        switch restorationIdentifier! {
            case "topRentals":
                moviesViewController.mode = .TopRentals
            default:
                moviesViewController.mode = .BoxOffice
        }
    }

}

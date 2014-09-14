//
//  MovieTableViewCell.swift
//  RottenTomatoes
//
//  Created by Jerry Su on 9/13/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: TTTAttributedLabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        let backgroundView = UIView()
        self.selectionStyle = .Default
        backgroundView.backgroundColor = .darkGrayColor()
        self.selectedBackgroundView = backgroundView
    }

}

//
//  HomeTableViewCell.swift
//  Move
//
//  Created by einmuya on 7/29/17.
//  Copyright © 2017 Crafted. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryDescription: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

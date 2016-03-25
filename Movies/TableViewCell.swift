//
//  TableViewCell.swift
//  Movies
//
//  Created by Leonardo Talero on 1/27/16.
//  Copyright © 2016 unir. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var image_: UIImageView!
    @IBOutlet weak var title_: UILabel!
    
    @IBOutlet weak var detail_: UILabel!

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var vote: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

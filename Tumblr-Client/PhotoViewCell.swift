//
//  PhotoViewCell.swift
//  Tumblr-Client
//
//  Created by Aarnav Ram on 02/02/17.
//  Copyright © 2017 Aarnav Ram. All rights reserved.
//

import UIKit

class PhotoViewCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var summary: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

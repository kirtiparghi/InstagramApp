//
//  SearchTableViewCell.swift
//  Instagram
//
//  Created by Vishal Verma on 2018-04-01.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var label_PhotoDesc: UILabel!
    @IBOutlet weak var imageview_UserPost: UIImageView!
    @IBOutlet weak var imageview_UserImage: UIImageView!
    @IBOutlet weak var label_Username: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

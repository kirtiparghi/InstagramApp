//
//  CommentCell.swift
//  Instagram
//
//  Created by Kirti Parghi on 3/27/18.
//  Copyright © 2018 Vishal Verma. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

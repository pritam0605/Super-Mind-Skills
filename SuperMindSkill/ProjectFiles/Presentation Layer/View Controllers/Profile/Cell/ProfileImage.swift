//
//  ProfileImage.swift
//  HMS
//
//  Created by Dipika on 09/01/20.
//  Copyright © 2020 MET Technologies. All rights reserved.
//

import UIKit

class ProfileImageCell: UITableViewCell {

    @IBOutlet weak var btnUploadPic: UIButton!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var imageUpload: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

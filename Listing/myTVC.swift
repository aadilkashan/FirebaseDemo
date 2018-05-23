//
//  myTVC.swift
//  Listing
//
//  Created by Apple's on 07/05/18.
//  Copyright © 2018 Aadil. All rights reserved.
//

import UIKit

class myTVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var myImg: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

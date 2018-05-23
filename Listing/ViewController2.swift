//
//  ViewController2.swift
//  Listing
//
//  Created by Apple's on 07/05/18.
//  Copyright © 2018 Aadil. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    
    var image : String!
    var imageName : String!
    var imgDesc : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl2.text = imageName
        sizeLbl2.text = imgDesc
        imgView2.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholderImag"))
    }

    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var nameLbl2: UILabel!
    
    @IBOutlet weak var sizeLbl2: UILabel!
    @IBOutlet weak var imgView2: UIImageView!
}

//
//  FamilyTableViewCell.swift
//  DiDe
//
//  Created by Deepak SK on 5/07/16.
//  Copyright © 2016 Mercury. All rights reserved.
//

import UIKit

class FamilyTableViewCell: UITableViewCell {

    @IBOutlet weak var trackingCountLabel: UILabel!
    @IBOutlet weak var familyMemberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  MajorTableViewCell.swift
//  DollarTranscriptClient
//
//  Created by Tendai Prince Dzonga on 6/7/17.
//  Copyright © 2017 Tendai Prince Dzonga. All rights reserved.
//

import UIKit

class MajorTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with major: Major) {
        
        name.text = major.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



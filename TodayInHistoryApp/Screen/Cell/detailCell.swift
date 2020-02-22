//
//  detailCell.swift
//  TodayInHistoryApp
//
//  Created by Dağhan KILIÇAY on 20.02.2020.
//  Copyright © 2020 Dağhan KILIÇAY. All rights reserved.
//

import UIKit

class detailCell: UITableViewCell {

    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

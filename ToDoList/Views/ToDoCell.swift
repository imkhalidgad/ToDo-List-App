//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Khalid Gad on 08/04/2024.
//

import UIKit

class ToDoCell: UITableViewCell {

    

    @IBOutlet weak var todoTitleLabel: UITextView!
    
    @IBOutlet weak var todoDateLabel: UILabel!
    
    @IBOutlet weak var todoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

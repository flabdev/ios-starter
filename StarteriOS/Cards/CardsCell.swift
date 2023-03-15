//
//  CardsCell.swift
//  StarteriOS
//
//  Created by Nagesh Kumar Mishra on 20/02/23.
//

import Foundation
import UIKit

class CardsCell: UITableViewCell {
 
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var userName: UILabel!
    var result: Cards? {
        didSet {
            userName.text = result?.userName
            cardNumber.text = result?.cardNumber
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

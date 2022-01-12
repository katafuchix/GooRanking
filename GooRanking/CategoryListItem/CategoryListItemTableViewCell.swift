//
//  CategoryListItemTableViewCell.swift
//  GooRanking
//
//  Created by cano on 2018/12/15.
//  Copyright © 2018 deskplate. All rights reserved.
//

import UIKit

class CategoryListItemTableViewCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.clear()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(_ categoryListItem: CategoryListItem) {
        self.clear()
        self.itemLabel.text = categoryListItem.item.trimmingCharacters(in: NSCharacterSet.newlines)
        self.summaryLabel.text = categoryListItem.summary.trimmingCharacters(in: NSCharacterSet.newlines)
        self.rankLabel.text = "\(categoryListItem.rank)位"
    }

    func clear() {
        self.rankLabel.text = ""
        self.itemLabel.text = ""
        self.summaryLabel.text = ""
    }

}

//
//  CategoryListTableViewCell.swift
//  GooRanking
//
//  Created by cano on 2018/12/15.
//  Copyright © 2018 deskplate. All rights reserved.
//

import UIKit

class CategoryListTableViewCell: UITableViewCell {

    @IBOutlet weak var listNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.clear()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(_ categoryList: CategoryList) {
        self.clear()
        self.listNameLabel.text = categoryList.title.trimmingCharacters(in: NSCharacterSet.newlines)
        //self.textLabel?.text = categoryList.title.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }

    func clear() {
        self.listNameLabel.text = ""
    }
}

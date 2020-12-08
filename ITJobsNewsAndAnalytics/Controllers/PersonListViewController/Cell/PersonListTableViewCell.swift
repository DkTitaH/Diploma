//
//  PersonListTableViewCell.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 01.12.2020.
//

import UIKit

struct PersonListTableViewCellModel {
    
    var language: String
    var salary: Int
    var position: String
}

class PersonListTableViewCell: UITableViewCell {
    
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var salaryLabel: UILabel!
    
    func fill(model: PersonListTableViewCellModel) {
        self.languageLabel.text = model.language
        self.positionLabel.text = model.position
        self.salaryLabel.text = model.salary.description
    }
}

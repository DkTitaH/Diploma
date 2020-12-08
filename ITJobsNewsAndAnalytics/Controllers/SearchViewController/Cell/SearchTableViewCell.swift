//
//  SearchTableViewCell.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 02.12.2020.
//

import UIKit

struct SearchTableViewCellModel {
    var name: String
    var salary: Double
}

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet var languageName: UILabel!
    @IBOutlet var salaryCount: UILabel!
    
    func fill(model: SearchTableViewCellModel) {
        self.languageName.text = model.name
        self.salaryCount.text = model.salary.description + "%"
    }
}

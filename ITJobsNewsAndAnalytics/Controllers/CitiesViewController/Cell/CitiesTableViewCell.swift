//
//  CitiesTableViewCell.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 28.11.2020.
//

import UIKit

class CitiesTableViewCell: UITableViewCell {
    
    @IBOutlet var cityName: UILabel?
    
    @IBOutlet var contentContainer: UIView?
    
    func fill(model: CityModel) {
        self.cityName?.text = model.name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.contentContainer?.backgroundColor = selected ? .init(red: 0, green: 0, blue: 0, alpha: 0.3) : .init(red: 0, green: 0, blue: 0, alpha: 0.1)
    }
}

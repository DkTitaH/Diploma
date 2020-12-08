//
//  AnalyticLanguageTypeTableViewCell.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 28.11.2020.
//

import UIKit

struct AnalyticLanguageType {
    
    let name: String
}

class AnalyticLanguageTypeTableViewCell: UITableViewCell {
    
    @IBOutlet var contentContainer: UIView?
    @IBOutlet var nameLabel: UILabel?

    func fill(model: AnalyticLanguageType) {
        self.nameLabel?.text = model.name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.contentContainer?.backgroundColor = selected ? .init(red: 0, green: 0, blue: 0, alpha: 0.3) : .init(red: 0, green: 0, blue: 0, alpha: 0.1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.prepareStyle()
    }
    
    private func prepareStyle() {
        let layer = self.contentContainer?.layer
        layer?.cornerRadius = 16
        layer?.borderWidth = 1
        layer?.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0.2)
        layer?.shadowOpacity = 1
        layer?.shadowOffset = .init(width: 0, height: 5)
        layer?.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
}

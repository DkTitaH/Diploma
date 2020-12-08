//
//  UITableView+Extensions.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 28.11.2020.
//

import UIKit

extension UITableView {

    func reusableCell<Result: UITableViewCell>(
        _ type: Result.Type,
        for indexPath: IndexPath,
        configure: (Result) -> Void
    )
        -> Result {
        let identifier = String(describing: type)

        let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        (cell as? Result).map(configure)

        guard let resultCell = cell as? Result else {
            fatalError("\(type.description()) - Identifire doesnt set to tableView")
        }

        return resultCell
    }

    ///Registering cell from nib for its self class
    func register(cellClass: AnyClass) {
        self.register(.nib(withClass: cellClass), forCellReuseIdentifier: String(describing: cellClass.self))
    }

    func dequeueReusableCell(withCellClass cellClass: AnyClass, for indexPath: IndexPath) -> UITableViewCell {
       return self.dequeueReusableCell(withIdentifier: toString(cellClass), for: indexPath)
    }
}

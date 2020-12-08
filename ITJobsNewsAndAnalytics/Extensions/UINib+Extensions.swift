//
//  UINib+Extensions.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 28.11.2020.
//

import Foundation

import UIKit

extension UINib {

    static func nib(withClass cls: AnyClass) -> UINib {
        return self.nib(withClass: cls, bundle: nil)
    }

    static func nib(withClass cls: AnyClass, bundle: Bundle?) -> UINib {
        return UINib(nibName: String(describing: cls), bundle: bundle)
    }
}

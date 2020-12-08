//
//  F.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 28.11.2020.
//

import Foundation

typealias EventHandler<T> = (T) -> Void

func toString(_ class: AnyClass) -> String {
    return String(describing: `class`)
}

public func cast<Value, Result>(_ value: Value) -> Result? {
    return value as? Result
}

public func when<Result>(_ condition: Bool, execute: () -> Result?) -> Result? {
    return condition ? execute() : nil
}

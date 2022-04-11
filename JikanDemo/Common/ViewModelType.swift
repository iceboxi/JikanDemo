//
//  ViewModelType.swift
//  JikanDemo
//
//  Created by ice on 2022/4/11.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

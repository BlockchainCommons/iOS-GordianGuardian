//
//  SeedProducer.swift
//  Fehu
//
//  Created by Wolf McNally on 12/11/20.
//

import Foundation

protocol SeedProducer {
    static func seed(values: [Self]) -> Data
}

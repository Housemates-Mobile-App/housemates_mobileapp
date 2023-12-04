//
//  DateValue.swift
//  housemates
//
//  Created by Bernard Sheng on 12/2/23.
//
import Foundation
struct DateValue: Identifiable {
  var id = UUID().uuidString
  var day: Int
  var date: Date
}

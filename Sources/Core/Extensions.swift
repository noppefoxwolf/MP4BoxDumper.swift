//
//  Extensions.swift
//  Core
//
//  Created by Tomoya Hirano on 2018/09/09.
//

import Foundation

extension InputStream {
  func read(maxLength: Int) -> (bytes: [UInt8], length: Int) {
    var tempArray = Array<UInt8>(repeating: 0, count: maxLength)
    let length = read(&tempArray, maxLength: maxLength)
    return (tempArray, length)
  }
}

extension Array where Element == UInt8 {
  var uint32Value: UInt32 {
    return UInt32(bigEndian: Data(bytes: self).withUnsafeBytes { $0.pointee })
  }
}

//
//  Dynamic.swift
//  Photos
//
//  Created by Kanan`s Macbook Pro on 11/30/21.
//

import Foundation

class Dynamic<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        self.value = v
    }
}

extension Dynamic: Equatable where T: Equatable {
    static func == (lhs: Dynamic<T>, rhs: Dynamic<T>) -> Bool {
        return lhs.value == rhs.value
    }
}

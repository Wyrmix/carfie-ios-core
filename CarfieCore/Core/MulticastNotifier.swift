//
//  MulticastNotifier.swift
//  CarfieCore
//
//  Created by Christopher Olsen on 9/18/19.
//  Copyright © 2019 espy. All rights reserved.
//

private final class Observer<T> {
    weak var reference: AnyObject?
    var block: (T) -> Void

    init(_ reference: AnyObject, block: @escaping (T) -> Void) {
        self.reference = reference
        self.block = block
    }
}

public final class MulticastNotifier<T> {
    private var observers: [Observer<T>] = []

    public init() {}

    public func subscribe(_ observer: AnyObject, withBlock block: @escaping (T) -> Void) {
        observers.append(Observer<T>(observer, block: block))
    }

    public func notify(withResult result: T) {
        removeStaleObservers()

        for observer in observers {
            observer.block(result)
        }
    }

    public func remove(_ observer: AnyObject) {
        observers = observers.filter({ $0.reference !== observer})
    }

    private func removeStaleObservers() {
        observers = observers.filter({ $0.reference != nil })
    }
}

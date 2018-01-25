//
//  Store.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import KleinKit

public protocol AppActionAsync: ActionAsync where StateType == AppState {
}

final public class Store: StoreBase<AppState, EntryPointReducer> {
    public static let shared: Store = {
        let global = Store()
        return global
    }()

    private init() {
        super.init(initialState: AppState(), reducer: EntryPointReducer())
    }
}

extension Store: ActionDispatcher { }
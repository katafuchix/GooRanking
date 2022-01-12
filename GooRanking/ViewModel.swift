//
//  ViewModel.swift
//  GooRanking
//
//  Created by cano on 2018/12/15.
//  Copyright © 2018 deskplate. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import RxFirebase

class ViewModel {

    let categories: Driver<[Category]>
    let error: Driver<Error>

    init () {
         (self.categories, self.error) = Driver.split(result: CategoryService.getCategories().resultDriver())
    }
}

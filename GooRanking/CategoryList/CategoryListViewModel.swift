//
//  CategoryListViewModel.swift
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

class CategoryListViewModel {

    let categoryLists: Driver<[CategoryList]>
    let error: Driver<Error>

    init ( category_id: Int) {
        (self.categoryLists, self.error) = Driver.split(result: CategoryService.getCategoryList(category_id: category_id).resultDriver())
    }
}

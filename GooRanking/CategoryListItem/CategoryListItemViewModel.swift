//
//  CategoryListItemViewModel.swift
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

class CategoryListItemViewModel {

    let categoryListItems: Driver<[CategoryListItem]>
    let error: Driver<Error>

    init (category_list_id: Int) {
        (self.categoryListItems, self.error) = Driver.split(result: CategoryService.getCategoryListItem(category_list_id: category_list_id).resultDriver())
    }
}

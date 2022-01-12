//
//  CategoryService.swift
//  GooRanking
//
//  Created by cano on 2018/12/15.
//  Copyright © 2018 deskplate. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import RxSwift
import RxCocoa
import RxFirebase

enum CategoryServiceFetchError: Error {
    case fetchError(Error?)
    case noExistsError
}

class CategoryService {

    private static let database = Firestore.firestore()

    static func getCategories() -> Observable<[Category]> {

       return database.collection("/category")
                .whereField("status", isEqualTo: 1)
                .rx.getDocuments()                  // QuerySnapshot
                .map { $0.documents }               // [QueryDocumentSnapshot]
                .map { $0.compactMap{ doc in return try? Category.init(from: doc) } } // [Category]

        /*
        return Firestore.firestore()
            .collection("category")
            .document("1")
            .rx.getDocument().map(Category.init)
        */
    }

    static func getCategoryList( category_id: Int ) -> Observable<[CategoryList]> {

        return database.collection("/category_list/category_id/\(category_id)")
            //.whereField("status", isEqualTo: 1)
            .rx.getDocuments()                  // QuerySnapshot
            .map { $0.documents }               // [QueryDocumentSnapshot]
            .map { $0.compactMap{ doc in return try? CategoryList.init(from: doc) } } // [CategoryList]
    }

    static func getCategoryListItem( category_list_id: Int ) -> Observable<[CategoryListItem]> {
print("/category_list_item/category_list_id/\(category_list_id)")
        return database.collection("/category_list_item/category_list_id/\(category_list_id)/")
            //.whereField("rank", isEqualTo: 1)
            .order(by: "rank", descending: false)
            .rx.getDocuments()                  // QuerySnapshot
            .map { $0.documents }               // [QueryDocumentSnapshot]
            .map { $0.compactMap{ doc in return try? CategoryListItem.init(from: doc) } } // [CategoryListItem]
    }
}

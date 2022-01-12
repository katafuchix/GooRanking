//
//  CategoryListViewController.swift
//  GooRanking
//
//  Created by cano on 2018/12/15.
//  Copyright © 2018 deskplate. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import NVActivityIndicatorView
import GoogleMobileAds

class CategoryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    var category_id: Int = 0

    private var viewModel: CategoryListViewModel!

    let categoryLists = BehaviorRelay<[CategoryList]?>(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        NVActivityIndicatorView.show()

        self.viewModel = CategoryListViewModel(category_id: self.category_id)

        self.tableView.separatorInset   = .zero
        self.tableView.tableFooterView  = UIView()
        self.tableView.tableHeaderView  = UIView()
        self.tableView.rowHeight = UITableView.automaticDimension

        self.categoryLists.asDriver().drive(onNext: { [unowned self] _ in
            self.tableView.reloadData()
            //NVActivityIndicatorView.dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                // 3秒後に実行
                NVActivityIndicatorView.dismiss()
            })
        }).disposed(by: rx.disposeBag)

        self.viewModel.categoryLists.asObservable()
            .bind(to: self.categoryLists)
            .disposed(by: rx.disposeBag)

        let bannerView = DFPBannerView(adSize: kGADAdSizeBanner)
        bannerView.center.x = self.view.bounds.size.width/2
        bannerView.center.y = self.bottomView.bounds.size.height/2
        self.bottomView.addSubview(bannerView)
        bannerView.adUnitID = "/9176203/61602"
        bannerView.rootViewController = self
        bannerView.load(DFPRequest())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navBar = self.navigationController?.navigationBar {
            for subview in navBar.subviews {
                subview.removeFromSuperview()
            }
        }
    }
}


extension CategoryListViewController : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryLists.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.categoryListTableViewCell, for: indexPath)!
        if let categoryList = self.categoryLists.value?[indexPath.row] {
            cell.configure(categoryList)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)

        guard let categpryList = self.categoryLists.value?[indexPath.row] else { return }
        let vc = R.storyboard.categoryListItem.categoryListItemViewController()!
        vc.category_list_id = categpryList.id
        vc.title = categpryList.title
        self.navigationController?.pushViewController(vc, animated: true)
    }
}




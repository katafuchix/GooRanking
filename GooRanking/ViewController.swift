//
//  ViewController.swift
//  GooRanking
//
//  Created by cano on 2018/12/12.
//  Copyright © 2018 deskplate. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import NVActivityIndicatorView
import GoogleMobileAds

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!

    private var viewModel: ViewModel!

    let caategories = BehaviorRelay<[Category]?>(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.title = "潮流ランク"

        NVActivityIndicatorView.show()

        self.viewModel = ViewModel()

        self.caategories.asDriver().drive(onNext: { [unowned self] _ in
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                NVActivityIndicatorView.dismiss()
            })
        }).disposed(by: rx.disposeBag)

        self.viewModel.categories.asObservable()
            .bind(to: self.caategories)
            .disposed(by: rx.disposeBag)

        let bannerView = DFPBannerView(adSize: kGADAdSizeBanner)
        bannerView.center.x = self.view.bounds.size.width/2
        bannerView.center.y = self.bottomView.bounds.size.height/2
            //self.tableView.frame.origin.y + self.tableView.bounds.size.height//self.view.frame.size.height - 50/2
        self.bottomView.addSubview(bannerView)
        bannerView.adUnitID = "/9176203/61602"
        bannerView.rootViewController = self
        bannerView.load(DFPRequest())
    }
}


extension ViewController : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.caategories.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = self.caategories.value?[indexPath.row].name
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = self.caategories.value?[indexPath.row] else { return }
        let vc = R.storyboard.categoryList.categoryListViewController()!
        vc.category_id = category.category_id
        vc.title = category.name
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


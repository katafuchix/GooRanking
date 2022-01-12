//
//  CategoryListItemViewController.swift
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
import Social
import GoogleMobileAds

class CategoryListItemViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    var category_list_id: Int = 0

    private var viewModel: CategoryListItemViewModel!

    let categoryListItems = BehaviorRelay<[CategoryListItem]?>(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        NVActivityIndicatorView.show()

        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationItem.backBarButtonItem = backButtonItem

        if let navBar = self.navigationController?.navigationBar {
            for subview in navBar.subviews {
                subview.removeFromSuperview()
            }
            let labelWidth = navBar.bounds.width - 80

            let label = UILabel(frame: CGRect(x:(navBar.bounds.width/2) - (labelWidth/2), y:0, width:labelWidth, height:navBar.bounds.height))
            label.backgroundColor = UIColor.clear
            label.numberOfLines = 0
            label.font = UIFont.boldSystemFont(ofSize: 13.0)
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.lineBreakMode = .byWordWrapping

            label.text = self.title
            self.navigationItem.titleView = label
            /*self.title = ""
            navBar.topItem?.title = nil
            navBar.addSubview(label)*/
        }

        self.tableView.separatorInset   = .zero
        self.tableView.tableFooterView  = UIView()
        self.tableView.tableHeaderView  = UIView()
        self.tableView.rowHeight = UITableView.automaticDimension

        self.viewModel = CategoryListItemViewModel(category_list_id: self.category_list_id)

        self.categoryListItems.asDriver().drive(onNext: { [unowned self] _ in
            self.tableView.reloadData()
            //NVActivityIndicatorView.dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                // 3秒後に実行
                NVActivityIndicatorView.dismiss()
            })
        }).disposed(by: rx.disposeBag)

        self.viewModel.categoryListItems.asObservable()
            .bind(to: self.categoryListItems)
            .disposed(by: rx.disposeBag)

        let bannerView = DFPBannerView(adSize: kGADAdSizeBanner)
        bannerView.center.x = self.view.bounds.size.width/2
        bannerView.center.y = self.bottomView.bounds.size.height/2
        self.bottomView.addSubview(bannerView)
        bannerView.adUnitID = "/9176203/61602"
        bannerView.rootViewController = self
        bannerView.load(DFPRequest())
    }
    
}


extension CategoryListItemViewController : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryListItems.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.categoryListItemCell, for: indexPath)!
        if let categoryListItem = self.categoryListItems.value?[indexPath.row] {
            cell.configure(categoryListItem)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)

        let item = self.categoryListItems.value?[indexPath.row]

        let actionSheet = UIAlertController(title: "", message: item?.item, preferredStyle: UIAlertController.Style.actionSheet)

        let action1 = UIAlertAction(title: "Google検索", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            //print("アクション１をタップした時の処理")
            self.presentWebView(indexPath)
        })

        let action2 = UIAlertAction(title: "Twitter", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            //print("アクション２をタップした時の処理")
            self.postTwitter(indexPath)
        })
        let action3 = UIAlertAction(title: "FaceBook", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            //print("アクション２をタップした時の処理")
            self.postFaceBook(indexPath)
        })

        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: {
            (action: UIAlertAction!) in
            //print("キャンセルをタップした時の処理")
        })

        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)

    }

    func postTwitter(_ indexPath:IndexPath) {
        if let item = self.categoryListItems.value?[indexPath.row], let title = self.title {
            let text = "\(title)\n \(item.rank)位 \(item.item) #潮流ランク"

            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc?.setInitialText(text)
            present(vc!, animated: true, completion: nil)
        }
    }

    func postFaceBook(_ indexPath:IndexPath) {
        if let item = self.categoryListItems.value?[indexPath.row], let title = self.title {
            let text = "\(title)\n \(item.rank)位 \(item.item) #潮流ランク"

            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            vc?.setInitialText(text)
            present(vc!, animated: true, completion: nil)
        }
    }

    func presentWebView(_ indexPath:IndexPath) {
        if let item = self.categoryListItems.value?[indexPath.row] {
            let url = "https://www.google.co.jp/search?q=" + item.item.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL(string: url)!)
            }

        }
    }

}




//
//  NVActivityIndicatorView.swift
//  GooRanking
//
//  Created by cano on 2018/12/15.
//  Copyright © 2018 deskplate. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import KRProgressHUD

extension NVActivityIndicatorView {

    open static func setup() {
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = UIColor.rgba(232, 118, 131)
        KRProgressHUD.set(maskType: .black)
        KRProgressHUD.set(style: .custom(background: UIColor.init(red:0,green:0,blue:0,alpha:0.7), text: UIColor.white, icon: UIColor.white))
    }

    public static func show(message: String? = nil) {
        let data = ActivityData(message: message)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(data, nil)
    }

    public static func dismiss() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }

    public static func showSuccess(message: String? = nil, image: String? = nil) {
        if image == nil {
            KRProgressHUD.showSuccess(withMessage: message)
        } else {
            KRProgressHUD.show(withMessage: message, completion: nil)
            let delay = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: delay) {
                KRProgressHUD.dismiss()
            }
        }

        // KRProgressHUD.showSuccess(message: message)
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }

    public static func showError(message: String? = nil) {
        KRProgressHUD.showError(withMessage: message)
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
}

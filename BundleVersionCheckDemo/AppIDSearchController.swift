//
//  AppIDSearchController.swift
//  BundleVersionCheckDemo
//
//  Created by 邓伟浩 on 2019/7/12.
//  Copyright © 2019 邓伟浩. All rights reserved.
//

//  Search base on AppID

import UIKit
import StoreKit

class AppIDSearchController: UIViewController {
    
    var textField: UITextField!
    var nameLabel: UILabel!
    var versionLabel: UILabel!
    var releaseLabel: UILabel!
    var currentReleaseLabel: UILabel!
    
    var submitBtn: UIButton!
    
    var downloadBtn: UIButton!
    var appStoreDownloadBtn: UIButton!
    
    var resultModel: WHBundleResultsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.title = SearchAppId
        
        textField = UITextField()
        textField.frame = CGRect(x: (UIScreen.main.bounds.size.width-300)/2, y: 100, width: 300, height: 50);
        self.view.addSubview(textField)
        textField.backgroundColor = UIColor.lightGray
        textField.layer.cornerRadius = 6
        textField.layer.masksToBounds = true
        textField.textAlignment = .center
        textField.text = kAPP_ID
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(valueChange), for: .editingChanged)
        
        submitBtn = UIButton(type: .custom)
        self.view.addSubview(submitBtn)
        submitBtn.setTitle("查询", for: .normal)
        submitBtn.setTitleColor(UIColor.white, for: .normal)
        submitBtn.backgroundColor = UIColor.black
        submitBtn.layer.cornerRadius = 6
        submitBtn.layer.masksToBounds = true
        submitBtn.frame = CGRect(x: (UIScreen.main.bounds.size.width-100)/2, y: textField.frame.maxY+20, width: 100, height: 30)
        submitBtn.addTarget(self, action: #selector(getBundleInfo), for: .touchUpInside)
        
        nameLabel = UILabel()
        self.view.addSubview(nameLabel)
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.frame = CGRect(x: 20, y: submitBtn.frame.maxY+5, width: UIScreen.main.bounds.size.width-40, height: 30)
        
        versionLabel = UILabel()
        self.view.addSubview(versionLabel)
        versionLabel.textColor = UIColor.black
        versionLabel.font = UIFont.systemFont(ofSize: 15)
        versionLabel.frame = CGRect(x: 20, y: nameLabel.frame.maxY+5, width: UIScreen.main.bounds.size.width-40, height: 30)
        
        releaseLabel = UILabel()
        self.view.addSubview(releaseLabel)
        releaseLabel.textColor = UIColor.black
        releaseLabel.font = UIFont.systemFont(ofSize: 15)
        releaseLabel.frame = CGRect(x: 20, y: versionLabel.frame.maxY+5, width: UIScreen.main.bounds.size.width-40, height: 30)
        
        currentReleaseLabel = UILabel()
        self.view.addSubview(currentReleaseLabel)
        currentReleaseLabel.textColor = UIColor.black
        currentReleaseLabel.font = UIFont.systemFont(ofSize: 15)
        currentReleaseLabel.frame = CGRect(x: 20, y: releaseLabel.frame.maxY+5, width: UIScreen.main.bounds.size.width-40, height: 30)
        
        downloadBtn = UIButton(type: .custom)
        self.view.addSubview(downloadBtn)
        downloadBtn.setTitle("应用内更新", for: .normal)
        downloadBtn.setTitleColor(UIColor.white, for: .normal)
        downloadBtn.backgroundColor = UIColor.purple
        downloadBtn.layer.cornerRadius = 6
        downloadBtn.layer.masksToBounds = true
        downloadBtn.frame = CGRect(x: (UIScreen.main.bounds.size.width-200)/2, y: currentReleaseLabel.frame.maxY+20, width: 200, height: 40)
        downloadBtn.addTarget(self, action: #selector(toDownLoad), for: .touchUpInside)
        downloadBtn.isHidden = true
        
        appStoreDownloadBtn = UIButton(type: .custom)
        self.view.addSubview(appStoreDownloadBtn)
        appStoreDownloadBtn.setTitle("前往AppStore商店更新", for: .normal)
        appStoreDownloadBtn.setTitleColor(UIColor.white, for: .normal)
        appStoreDownloadBtn.backgroundColor = UIColor.lightGray
        appStoreDownloadBtn.layer.cornerRadius = 6
        appStoreDownloadBtn.layer.masksToBounds = true
        appStoreDownloadBtn.frame = CGRect(x: (UIScreen.main.bounds.size.width-200)/2, y: downloadBtn.frame.maxY+20, width: 200, height: 40)
        appStoreDownloadBtn.addTarget(self, action: #selector(toAppStoreUpdate), for: .touchUpInside)
        appStoreDownloadBtn.isHidden = true
        
        self.clearText()
    }
    
    func clearText() {
        self.nameLabel.text = "App名称: "
        self.versionLabel.text = "版本号: "
        self.releaseLabel.text = "发布时间: "
        self.currentReleaseLabel.text = "最近发布时间: "
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func getBundleInfo() {
        Service.request(target: Starget.bundleVersionCheck(id: kAPP_ID), model: WHBundleModel.self, success: { (res) in
            if res.resultCount != 0 {
                if let model = res.results?.first {
                    self.resultModel = model
                    self.nameLabel.text = "App名称: \(model.trackName)"
                    self.versionLabel.text = "版本号: \(model.version)"
                    self.releaseLabel.text = "发布时间: \(model.releaseDate)"
                    self.currentReleaseLabel.text = "最近发布时间: \(model.currentVersionReleaseDate)"
                    self.downloadBtn.isHidden = false
                    self.appStoreDownloadBtn.isHidden = false
                    
                    
                    UIAlertController.showAlert(title: "新版内容", message: model.releaseNotes, cancelTitle: "取消")
                } else {
                    self.clearText()
                    self.downloadBtn.isHidden = true
                    self.appStoreDownloadBtn.isHidden = true
                }
                
            } else {
                UIAlertController.showAlert(message: "未查询到App")

                self.clearText()
                self.downloadBtn.isHidden = true
                self.appStoreDownloadBtn.isHidden = true
            }
        }) {
            
        }
    }
    
    @objc func valueChange() {
        kAPP_ID = textField.text ?? ""
    }
    
    @objc func toAppStoreUpdate() {
        UIApplication.shared.open(URL(string: self.resultModel!.trackViewUrl)!, options: [:], completionHandler: nil)
    }
    
    @objc func toDownLoad() {
        let storeProductVC = SKStoreProductViewController()
        storeProductVC.delegate = self
        storeProductVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : kAPP_ID], completionBlock: { (result, error) in
            if error == nil{
                print(result)
            }else{
                print(error!)
            }
        })
        self.present(storeProductVC, animated: true, completion: nil)
    }
}

extension AppIDSearchController: SKStoreProductViewControllerDelegate {
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension UIAlertController {
    class func showAlert(title:String = "",
                         message:String?,
                         messageColor:UIColor = UIColor.black,
                         messageFont:UIFont = UIFont.systemFont(ofSize: 15),
                         trueTitle:String = "确定",
                         trueTitleColor:UIColor? = nil,
                         trueHandler: ((UIAlertAction) -> Void)? = nil,
                         cancelTitle:String? = nil,
                         cancelTitleColor:UIColor = UIColor.red,
                         cancleHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertControllerMessageStr = NSMutableAttributedString.init(string: message ?? "", attributes: [
            .foregroundColor: messageColor,
            .font: messageFont
            ])
        alertController.setValue(alertControllerMessageStr, forKey: "attributedMessage")
        
        let trueAction = UIAlertAction.init(title: trueTitle, style: .default, handler: trueHandler)
        trueAction.setValue(trueTitleColor, forKey: "_titleTextColor")
        alertController.addAction(trueAction)
        
        if cancelTitle != nil {
            let cancelAction = UIAlertAction.init(title: cancelTitle, style: .cancel, handler: cancleHandler)
            cancelAction.setValue(cancelTitleColor, forKey: "_titleTextColor")
            alertController.addAction(cancelAction)
            
        }
        
        let alertWindow = UIWindow.init(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
}



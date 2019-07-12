//
//  AppNameSearchController.swift
//  BundleVersionCheckDemo
//
//  Created by 邓伟浩 on 2019/7/12.
//  Copyright © 2019 邓伟浩. All rights reserved.
//

import UIKit
import StoreKit
import YYKit

class AppNameSearchController: UIViewController {
    
    var results: [WHBundleResultsModel]?
    
    var textField: UITextField!
    var submitBtn: UIButton!
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        self.navigationItem.title = SearchAppName
        
        textField = UITextField()
        textField.frame = CGRect(x: (UIScreen.main.bounds.size.width-300)/2, y: 100, width: 300, height: 50);
        self.view.addSubview(textField)
        textField.backgroundColor = UIColor.lightGray
        textField.layer.cornerRadius = 6
        textField.layer.masksToBounds = true
        textField.textAlignment = .center
        textField.text = kAPP_Name
        textField.keyboardType = .default
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
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: submitBtn.frame.maxY+20, width: self.view.bounds.size.width, height: self.view.bounds.size.height-submitBtn.frame.maxY-20), style: .plain)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.register(SearchResultInfoCell.self, forCellReuseIdentifier: NSStringFromClass(SearchResultInfoCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
    }

    @objc func valueChange() {
        kAPP_Name = textField.text ?? ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func getBundleInfo() {
        Service.request(target: Starget.searchApp(term: kAPP_Name), model: WHBundleModel.self, success: { (res) in
            if res.resultCount != 0 {
                self.results = res.results
            } else {
                UIAlertController.showAlert(message: "未查询到App")
                self.results = nil
            }
            self.tableView.reloadData()
        }) {
            self.results = nil
            self.tableView.reloadData()
        }
    }
}

extension AppNameSearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SearchResultInfoCell.self), for: indexPath) as! SearchResultInfoCell
        let model = self.results![indexPath.row]
        
//        cell.tipImageView.image = nil
//        DispatchQueue.global().async {
//            do {
//                let data = try Data.init(contentsOf: URL.init(string: model.artworkUrl60)!)
//                DispatchQueue.main.async {
//                    cell.tipImageView.image = UIImage.init(data: data)
//                }
//
//            } catch {
//            }
//        }
        
        cell.tipImageView.setImageWith(URL.init(string: model.artworkUrl60), options: .ignoreDiskCache)
        
        
        cell.tipLabel.text = model.trackName
        cell.desLabel.text = model.version
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = self.results![indexPath.row]
        UIAlertController.showAlert(title: "\(model.trackName)-新版内容", message: model.releaseNotes, trueHandler: { (action) in
            
            let storeProductVC = SKStoreProductViewController()
            storeProductVC.delegate = self
            storeProductVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : model.trackId], completionBlock: { (result, error) in
                if error == nil{
                    print(result)
                }else{
                    print(error!)
                }
            })
            self.present(storeProductVC, animated: true, completion: nil)
            
        }, cancelTitle: "取消")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension AppNameSearchController: SKStoreProductViewControllerDelegate {
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}


class SearchResultInfoCell: UITableViewCell {
    var tipLabel = UILabel()
    var desLabel = UILabel()
    var tipImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpUI() {
        self.contentView.addSubview(tipImageView)
        tipImageView.frame = CGRect(x: 20, y: 20, width: 40, height: 40);
        
        self.contentView.addSubview(tipLabel)
        tipLabel.frame = CGRect(x: tipImageView.frame.maxX+10, y: 15, width: 300, height: 20)
        self.contentView.addSubview(desLabel)
        desLabel.frame = CGRect(x: tipImageView.frame.maxX+10, y: 40, width: 300, height: 20)
    }
}

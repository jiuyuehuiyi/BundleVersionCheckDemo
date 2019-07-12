//
//  ViewController.swift
//  BundleVersionCheckDemo
//
//  Created by 邓伟浩 on 2019/7/12.
//  Copyright © 2019 邓伟浩. All rights reserved.
//



import UIKit

let SearchAppId         =       "Search base on AppID"
let SearchAppName       =       "Search base on AppName"
var kAPP_ID             =       "1446453695"
var kAPP_Name           =       "彬峰快运"


class ViewController: UIViewController {
    let tipArray = [SearchAppId, SearchAppName]
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "AppStore版本检测Demo"
        
        self.setUpTableView()
    }
    
    private func setUpTableView() {
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height), style: .plain)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        if (tableView.superview == nil) {
            self.view.addSubview(tableView)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = tipArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(AppIDSearchController(), animated: true)
        } else {
            self.navigationController?.pushViewController(AppNameSearchController(), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

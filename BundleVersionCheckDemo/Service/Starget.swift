//
//  Starget.swift
//  BundleVersionCheckDemo
//
//  Created by 邓伟浩 on 2019/7/12.
//  Copyright © 2019 邓伟浩. All rights reserved.
//

import UIKit
import Moya

let ITUNESURL                 = "https://itunes.apple.com/"

let VersionCheck_API          = "cn/lookup"
let SearchApp_API             = "search"



public enum Starget {
    
    case bundleVersionCheck(id: String)
    case searchApp(term: String)
}

extension Starget: TargetType {
    public var baseURL: URL {
        return URL(string: ITUNESURL)!
    }
    
    public var path: String {
        switch self {
        case .bundleVersionCheck:       return VersionCheck_API
        case .searchApp:                return SearchApp_API
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        /// 无参请求
        case .bundleVersionCheck(let id):
            return queryTask(["id":id])
        case .searchApp(let term):
            return queryTask(["term":term, "entity": "software"])
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    func queryTask(_ param: [String : Any]? = nil) -> Task {
        let param = param ?? [:]
        
        return param.queryTask
    }
    
}

fileprivate extension Dictionary {
    var queryTask:Task {
        get{ return Task.requestParameters(parameters: self as! [String : Any], encoding: URLEncoding.queryString) }
    }
    var jsonTask: Task {
        get{ return Task.requestParameters(parameters: self as! [String : Any], encoding: JSONEncoding.default) }
    }
}

// MARK: - Helpers
fileprivate extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

//
//  Service.swift
//  BundleVersionCheckDemo
//
//  Created by 邓伟浩 on 2019/7/12.
//  Copyright © 2019 邓伟浩. All rights reserved.
//

import UIKit
import Moya
import HandyJSON

/// 请求超时时间
let timeOut:TimeInterval = 20

/// 状态栏网络请求状态
let spinerPlugin = NetworkActivityPlugin { (state, targetType) in
    if state == .began{
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }else{
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

/// 打印网络请求日志
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data
    }
}

open class Service: Any {
    
    static let provider = MoyaProvider<Starget>(requestClosure: { (endpoint, done) in
        var request: URLRequest = try! endpoint.urlRequest()
        request.timeoutInterval = timeOut
        request.cachePolicy = .reloadIgnoringLocalCacheData
        done(.success(request))
    },plugins: [spinerPlugin,NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)],
      trackInflights: true)
    
    /// request
    ///
    /// - Parameters:
    ///   - target: 网络请求
    ///   - model:  模型
    ///   - success: 成功回调
    ///   - failure: 失败回调
    public static func request<T: HandyJSON>(target: Starget, model:T.Type, success: @escaping ((T)-> Void), failure: (()-> Void)? ) {
        provider.request(target) { (result) in
            switch result {
            case .success(let value):
                switch value.response!.statusCode {
                case 200:
                    if let res = T.deserialize(from: String(data:  value.data, encoding: .utf8)) {
                        success(res)
                    } else {
                        failure?()
                    }
                default:
                    failure?()
                    break
                }
            case .failure(_):
                failure?()
            }
        }
    }
    
    

}

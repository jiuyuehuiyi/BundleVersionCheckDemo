//
//  WHBundleModel.swift
//  BundleVersionCheckDemo
//
//  Created by 邓伟浩 on 2019/7/12.
//  Copyright © 2019 邓伟浩. All rights reserved.
//


import HandyJSON

struct WHBundleModel: HandyJSON {
    
    var resultCount: Int = 0
    var results: [WHBundleResultsModel]?
}

struct WHBundleResultsModel: HandyJSON {
    var primaryGenreName: String = "" // 应用类别
    var artworkUrl100: String = "" // 应用图标 100X100
    var sellerUrl: String = "" // 开发者支持网站
    var currency: String = "" // CNY
    var artworkUrl512: String = "" // 应用图标 512X512
    var ipadScreenshotUrls: [String] = [String]()
    var fileSizeBytes: UInt64 = 0
    var genres: [String] = [String]()
    var languageCodesISO2A: [String] = [String]()
    var artworkUrl60: String = "" // 应用图标 60X60
    var supportedDevices: [String] = [String]()
    var trackViewUrl: String = "" // 应用程序介绍网址
    var description: String = ""
    var version: String = "" // 版本信息
    var bundleId: String = ""
    var artistViewUrl: String = ""
    var releaseDate: String = ""
    var isGameCenterEnabled: Bool = false
    var appletvScreenshotUrls: [String] = [String]()
    var genreIds: [String] = [String]()
    var wrapperType: String = ""
    var trackId: String = "" // 应用程序 ID
    var minimumOsVersion: String = ""
    var formattedPrice: String = ""
    var primaryGenreId: String = ""
    var currentVersionReleaseDate: String = ""
    var artistId: String = "" // 开发者 ID
    var trackContentRating: String = "" // 评级
    var artistName: String = "" // 开发者名称
    var price: Double = 0
    var trackCensoredName: String = "" // 审查名称
    var trackName: String = "" // 应用程序名称
    var kind: String = ""
    var features: [String] = [String]()
    var contentAdvisoryRating: String = ""
    var screenshotUrls: [String] = [String]()
    var releaseNotes: String = ""
    var isVppDeviceBasedLicensingEnabled: String = ""
    var sellerName: String = ""
    var advisories: [String] = [String]()
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            releaseDate <-- TZTimeStringTransform(originFormatterString: "yyyy-MM-dd'T'HH:mm:ssZ", formatString: "yyyy-MM-dd HH:mm:ss")
        mapper <<<
            currentVersionReleaseDate <-- TZTimeStringTransform(originFormatterString: "yyyy-MM-dd'T'HH:mm:ssZ", formatString: "yyyy-MM-dd HH:mm:ss")
    }
}

class TZTimeStringTransform: TransformType {
    
    public typealias Object = String
    public typealias JSON = String
    
    public let dateFormatter: DateFormatter
    public let originFormatter: DateFormatter
    
    public init(originFormatterString: String, formatString: String) {
        let originFormatter = DateFormatter()
        originFormatter.dateFormat = originFormatterString
        self.originFormatter = originFormatter
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        self.dateFormatter = dateFormatter
    }
    
    public func transformFromJSON(_ value: Any?) -> String? {
        if let valueStr = value as? String {
            let date = originFormatter.date(from: valueStr)!
            return dateFormatter.string(from: date)
            
        }
        return nil
    }
    
    public func transformToJSON(_ value: String?) -> String? {
        if let dateString = value {
            let date = dateFormatter.date(from: dateString)!
            return originFormatter.string(from: date)
        }
        return nil
    }
}

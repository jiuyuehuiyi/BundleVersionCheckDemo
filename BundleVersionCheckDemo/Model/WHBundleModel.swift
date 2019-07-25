//
//  WHBundleModel.swift
//  BundleVersionCheckDemo
//
//  Created by 邓伟浩 on 2019/7/12.
//  Copyright © 2019 邓伟浩. All rights reserved.
//


import HandyJSON

public struct WHBundleModel: HandyJSON {
    
    public var resultCount: Int = 0
    public var results: [WHBundleResultsModel]?
    
    public init() {}
}

public struct WHBundleResultsModel: HandyJSON {
    public init() {}
    
    public var primaryGenreName: String = "" // 应用类别
    public var artworkUrl100: String = "" // 应用图标 100X100
    public var sellerUrl: String = "" // 开发者支持网站
    public var currency: String = "" // CNY
    public var artworkUrl512: String = "" // 应用图标 512X512
    public var ipadScreenshotUrls: [String] = [String]()
    public var fileSizeBytes: UInt64 = 0
    public var genres: [String] = [String]()
    public var languageCodesISO2A: [String] = [String]()
    public var artworkUrl60: String = "" // 应用图标 60X60
    public var supportedDevices: [String] = [String]()
    public var trackViewUrl: String = "" // 应用程序介绍网址
    public var description: String = ""
    public var version: String = "" // 版本信息
    public var bundleId: String = ""
    public var artistViewUrl: String = ""
    public var releaseDate: String = ""
    public var isGameCenterEnabled: Bool = false
    public var appletvScreenshotUrls: [String] = [String]()
    public var genreIds: [String] = [String]()
    public var wrapperType: String = ""
    public var trackId: String = "" // 应用程序 ID
    public var minimumOsVersion: String = ""
    public var formattedPrice: String = ""
    public var primaryGenreId: String = ""
    public var currentVersionReleaseDate: String = ""
    public var artistId: String = "" // 开发者 ID
    public var trackContentRating: String = "" // 评级
    public var artistName: String = "" // 开发者名称
    public var price: Double = 0
    public var trackCensoredName: String = "" // 审查名称
    public var trackName: String = "" // 应用程序名称
    public var kind: String = ""
    public var features: [String] = [String]()
    public var contentAdvisoryRating: String = ""
    public var screenshotUrls: [String] = [String]()
    public var releaseNotes: String = ""
    public var isVppDeviceBasedLicensingEnabled: String = ""
    public var sellerName: String = ""
    public var advisories: [String] = [String]()
    
    public mutating func mapping(mapper: HelpingMapper) {
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

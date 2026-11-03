//
//  AdConfig.swift
//  UzaoCalucurate
//
//  AdMob のバナー広告ユニットID。
//  AdMob アプリID は Info.plist (GADApplicationIdentifier) に設定している。
//

import Foundation

enum AdConfig {
    #if DEBUG
    /// Google 公式のテスト用バナー広告ユニットID（開発中に本番広告を表示しないため）
    static let bannerUnitID = "ca-app-pub-3940256099942544/2435281174"
    #else
    /// 本番用バナー広告ユニットID
    static let bannerUnitID = "ca-app-pub-4859622277330192/8687328084"
    #endif
}

//
//  AdConsentManager.swift
//  UzaoCalucurate
//
//  同意取得 (Google UMP) → ATT 許可リクエスト → AdMob SDK 初期化 の順に実行する。
//

import SwiftUI
import Combine
import GoogleMobileAds
import UserMessagingPlatform
import AppTrackingTransparency

@MainActor
final class AdConsentManager: ObservableObject {
    /// true になったらバナー広告を読み込んでよい
    @Published private(set) var canShowAds = false

    private var hasStarted = false

    func gatherConsentAndStartAds() async {
        guard !hasStarted else { return }
        hasStarted = true

        // 1. UMP: EEA / 英国などで必要な同意フォームを（必要な場合のみ）表示
        let parameters = RequestParameters()
        parameters.isTaggedForUnderAgeOfConsent = false
        do {
            try await ConsentInformation.shared.requestConsentInfoUpdate(with: parameters)
            try await ConsentForm.loadAndPresentIfRequired(from: nil)
        } catch {
            // 取得に失敗しても、前回までの同意状態で canRequestAds を判定する
        }

        guard ConsentInformation.shared.canRequestAds else { return }

        // 2. ATT: トラッキング許可ダイアログ（未決定の場合のみ表示される）
        _ = await ATTrackingManager.requestTrackingAuthorization()

        // 3. AdMob SDK 初期化
        await MobileAds.shared.start()
        canShowAds = true
    }
}

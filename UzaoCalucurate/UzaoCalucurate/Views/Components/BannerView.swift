//
//  BannerView.swift
//  UzaoCalculator
//
//  AdMob banner wrapper.
//  When Google Mobile Ads SDK is not linked the view falls back to
//  a static placeholder so the project always compiles.
//

import SwiftUI

// MARK: - Public API

struct BannerView: View {
    var body: some View {
        #if canImport(GoogleMobileAds)
        AdMobBannerRepresentable()
            .frame(height: 50)
        #else
        // Fallback placeholder when AdMob SDK is not installed
        BannerPlaceholder()
        #endif
    }
}

// MARK: - Placeholder (no SDK)

private struct BannerPlaceholder: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: 50)
            .overlay(
                Text("広告スペース")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            )
    }
}

// MARK: - Real AdMob banner (only compiled when SDK is present)

#if canImport(GoogleMobileAds)
import GoogleMobileAds

private struct AdMobBannerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        // Test ad unit – replace with your own before release
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = viewController
        viewController.view.addSubview(bannerView)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        bannerView.load(GADRequest())
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
#endif

#Preview {
    BannerView()
}

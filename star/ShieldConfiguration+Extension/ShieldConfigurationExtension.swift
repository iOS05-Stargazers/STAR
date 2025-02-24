//
//  ShieldConfigurationExtension.swift
//  ShieldConfiguration+Extension
//
//  Created by t0000-m0112 on 2025-02-18.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    
    // TODO: - Localizable 적용
    
    private let currentLocale = Locale.current.languageCode
    
    private func localizedText(for tokenName: String) -> String {
        switch currentLocale {
        case "ko":
            return "\(tokenName)은(는)\n사용이 제한되었습니다."
        default:
            return "\(tokenName) is restricted."
        }
    }
    
    private func localizedExitButton() -> String {
        switch currentLocale {
        case "ko":
            return "종료하기"
        default:
            return "Exit"
        }
    }
    
    private func localizedUnknownApp() -> String {
        switch currentLocale {
        case "ko":
            return "확인불가 앱"
        default:
            return "Unknown App"
        }
    }
    
    private func localizedUnknownWeb() -> String {
        switch currentLocale {
        case "ko":
            return "확인불가 웹 도메인"
        default:
            return "Unknown Web Domain"
        }
    }
    
    private func setShieldConfig(
        _ tokenName: String) -> ShieldConfiguration {
            let customIcon = UIImage(named: "AppSymbol.png")
            
            let customTitle = ShieldConfiguration.Label(
                text: "S T A R",
                color: .starPrimaryText
            )
            
            let customSubtitle = ShieldConfiguration.Label(
                text: localizedText(for: tokenName),
                color: .starSecondaryText
            )
            
            let customPrimaryButtonLabel = ShieldConfiguration.Label(
                text: localizedExitButton(),
                color: .starPrimaryText
            )
            
            let shieldConfiguration = ShieldConfiguration(
                backgroundBlurStyle: .none,
                backgroundColor: .starAppBG,
                icon: customIcon,
                title: customTitle,
                subtitle: customSubtitle,
                primaryButtonLabel: customPrimaryButtonLabel,
                primaryButtonBackgroundColor: .starDisabledTagBG
            )
            
            return shieldConfiguration
        }
    
    
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        guard let displayName = application.localizedDisplayName else {
            return setShieldConfig(localizedUnknownApp())
        }
        return setShieldConfig(displayName)
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        guard let displayName = application.localizedDisplayName,
              let categoryName = category.localizedDisplayName else {
            return setShieldConfig(localizedUnknownApp())
        }
        return setShieldConfig(categoryName + " " + displayName)
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        guard let displayName = webDomain.domain else {
            return setShieldConfig(localizedUnknownWeb())
        }
        return setShieldConfig(displayName)
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        guard let displayName = webDomain.domain,
              let categoryName = category.localizedDisplayName else {
            return setShieldConfig(localizedUnknownWeb())
        }
        return setShieldConfig(categoryName + " " + displayName)
    }
}

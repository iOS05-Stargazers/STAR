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
    
    private func setShieldConfig(
        _ tokenName: String) -> ShieldConfiguration {
            let customIcon = UIImage.logo
            
            let customTitle = ShieldConfiguration.Label(
                text: "S T A R",
                color: .starPrimaryText
            )
            
            let customSubtitle = ShieldConfiguration.Label(
                text: String(format: "shield.restricted_message".localized, tokenName),
                color: .starSecondaryText
            )
            
            let customPrimaryButtonLabel = ShieldConfiguration.Label(
                text: "shield.exit_button".localized,
                color: .starPrimaryText
            )
            
            let shieldConfiguration = ShieldConfiguration(
                backgroundBlurStyle: .dark,
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
            return setShieldConfig("shield.unknown_app".localized)
        }
        return setShieldConfig(displayName)
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        guard let displayName = application.localizedDisplayName,
              let categoryName = category.localizedDisplayName else {
            return setShieldConfig("shield.unknown_app".localized)
        }
        return setShieldConfig(categoryName + " " + displayName)
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        guard let displayName = webDomain.domain else {
            return setShieldConfig("shield.unknown_web".localized)
        }
        return setShieldConfig(displayName)
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        guard let displayName = webDomain.domain,
              let categoryName = category.localizedDisplayName else {
            return setShieldConfig("shield.unknown_web".localized)
        }
        return setShieldConfig(categoryName + " " + displayName)
    }
}

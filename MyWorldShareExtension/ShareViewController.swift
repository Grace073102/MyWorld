//
//  ShareViewController.swift
//  MyWorldShareExtension
//
//  Created by Grace Chi Yen Chong on 5/10/2026.
//

import UIKit
import Social
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {

    private let appGroup = "group.com.gracechong.MyWorld"

    override func isContentValid() -> Bool {
        true
    }

    override func didSelectPost() {
        if !contentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            saveSharedContent(contentText)
        }

        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = extensionItem.attachments else {
            completeRequest()
            return
        }

        for provider in attachments {
            if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] item, _ in
                    if let url = item as? URL {
                        self?.saveSharedContent(url.absoluteString)
                    }
                    self?.completeRequest()
                }
                return
            }

            if provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { [weak self] item, _ in
                    if let text = item as? String {
                        self?.saveSharedContent(text)
                    }
                    self?.completeRequest()
                }
                return
            }
        }

        completeRequest()
    }

    override func configurationItems() -> [Any]! {
        []
    }

    private func saveSharedContent(_ content: String) {
        let defaults = UserDefaults(suiteName: appGroup)
        defaults?.set(content, forKey: "sharedContent")
        defaults?.set(Date(), forKey: "sharedContentDate")
    }

    private func completeRequest() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

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
        return true
    }

    override func didSelectPost() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = extensionItem.attachments else {
            saveContentText()
            return
        }

        for provider in attachments {
            if provider.canLoadObject(ofClass: NSURL.self) {
                provider.loadObject(ofClass: NSURL.self) { [weak self] object, error in
                    if let url = object as? URL {
                        self?.saveSharedContent(url.absoluteString)
                    } else if let error {
                        print("Share URL error: \(error.localizedDescription)")
                    }

                    self?.completeRequest()
                }
                return
            }

            if provider.canLoadObject(ofClass: NSString.self) {
                provider.loadObject(ofClass: NSString.self) { [weak self] object, error in
                    if let text = object as? String {
                        self?.saveSharedContent(text)
                    } else if let error {
                        print("Share text error: \(error.localizedDescription)")
                    }

                    self?.completeRequest()
                }
                return
            }
        }

        saveContentText()
    }

    override func configurationItems() -> [Any]! {
        return []
    }

    private func saveContentText() {
        let text = contentText.trimmingCharacters(in: .whitespacesAndNewlines)

        if !text.isEmpty {
            saveSharedContent(text)
        }

        completeRequest()
    }

    private func saveSharedContent(_ content: String) {
        guard !content.isEmpty else {
            return
        }

        let defaults = UserDefaults(suiteName: appGroup)
        defaults?.set(content, forKey: "sharedContent")
        defaults?.set(Date(), forKey: "sharedContentDate")
    }

    private func completeRequest() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

//
//  AddImageIntent.swift
//  AddImageIntent
//
//  Created by Jaikrishnan N on 03/08/24.
//

import AppIntents

struct AddImageIntent: AppIntent {
    @available(iOS 16, *)
    static var title: LocalizedStringResource = "Add Image"
    
    @available(iOS 16.0, *)
    static var description = IntentDescription("This intent allows you to add an image to MyApp.")
    
    @available(iOS 16, *)
    static var shortcutPhrase: LocalizedStringResource = "Add image to MyApp"

    @available(iOS 16.0, *)
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // Custom logic to add an image
        return .result(dialog: "Image added successfully to MyApp.")
    }
}

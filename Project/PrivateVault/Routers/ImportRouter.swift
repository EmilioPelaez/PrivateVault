//
//  ImportRouter.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 26/04/22.
//

import ImportScreens
import SharedUI
import SwiftUI

struct ImportRouter: ViewModifier {
	@State var importAction: ImportType?
	
	func body(content: Content) -> some View {
		content
			.handleEvent(ImportEvent.self) { importAction = $0.type }
			.fileImporter(isPresented: $importAction.for(.document), allowedContentTypes: [.item], allowsMultipleSelection: true) { _ in }
			.cameraImporter(isPresented: $importAction.for(.camera)) { _ in }
			.documentScanner(isPresented: $importAction.for(.scan)) { _ in }
			.mediaImporter(isPresented: $importAction.for(.album)) { _ in }
	}
}

extension View {
	///	Handles import events to show importer screens
	func importRouter() -> some View {
		modifier(ImportRouter())
	}
}

extension Binding where Value == ImportType? {
	func `for`(_ type: ImportType) -> Binding<Bool> {
		Binding<Bool> {
			self.wrappedValue == type
		} set: { _ in
			self.wrappedValue = nil
		}

	}
}

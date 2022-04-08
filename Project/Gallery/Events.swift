//
//  Events.swift
//  Gallery
//
//  Created by Emilio Peláez on 08/04/22.
//

import HierarchyResponder
import SwiftUI

public struct ItemSelectedEvent: Event {
	public let item: GalleryItem
}

public struct ItemContextEvent: Event {
	public enum Action: CaseIterable {
		case edit, share, move, delete
	}
	
	public let item: GalleryItem
	public let action: Action
}

extension ItemContextEvent.Action: Identifiable {
	public var id: String { title }
}

extension ItemContextEvent.Action {
	var title: String {
		switch self {
		case .edit: return "Edit"
		case .share: return "Share"
		case .move: return "Move"
		case .delete: return "Delete"
		}
	}

	var systemImage: String {
		switch self {
		case .edit: return "square.and.pencil"
		case .share: return "square.and.arrow.up"
		case .move: return "folder.badge.plus"
		case .delete: return "trash"
		}
	}
	
	var role: ButtonRole? {
		self == .delete ? .destructive : nil
	}
}

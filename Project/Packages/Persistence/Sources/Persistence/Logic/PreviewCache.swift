//
//  PreviewCache.swift
//  PrivateVault
//
//  Created by Emilio Peláez on 25/2/21.
//

import SwiftUI

public class PreviewCache {
	
	public class Wrapper {
		let image: Image
		init(image: Image) {
			self.image = image
		}
	}
	
	public static let shared = PreviewCache()
	
	public var cache = NSCache<NSString, Wrapper>()
	public var failedIds = Set<NSString>()
	
	public func cachedImage(for item: StoredItem) -> Image? {
		guard let id = item.id as NSString? else { return nil }
		guard !failedIds.contains(id) else { return nil }
		if let value = cache.object(forKey: id) { return value.image }
		guard let image = item.generatePreview() else {
			failedIds.insert(id)
			return nil
		}
		cache.setObject(Wrapper(image: image), forKey: id)
		return image
	}
	
}

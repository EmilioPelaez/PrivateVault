//
//  StoredItem.swift
//  Persistence
//
//  Created by Emilio Peláez on 4/10/26.
//

import CoreData

@objc(StoredItem)
public class StoredItem: NSManagedObject {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<StoredItem> {
		NSFetchRequest<StoredItem>(entityName: "StoredItem")
	}
	
	@NSManaged public var data: Data?
	@NSManaged public var dataTypeValue: Int16
	@NSManaged public var fileExtension: String?
	@NSManaged public var id: String?
	@NSManaged public var name: String?
	@NSManaged public var previewData: Data?
	@NSManaged public var remoteUrl: URL?
	@NSManaged public var timestamp: Date?
	@NSManaged public var folder: Folder?
	@NSManaged public var tags: NSSet?
}

public extension StoredItem {
	@objc(addTagsObject:)
	@NSManaged func addToTags(_ value: Tag)
	
	@objc(removeTagsObject:)
	@NSManaged func removeFromTags(_ value: Tag)
	
	@objc(addTags:)
	@NSManaged func addToTags(_ values: NSSet)
	
	@objc(removeTags:)
	@NSManaged func removeFromTags(_ values: NSSet)
}

extension StoredItem: Identifiable {}

//
//  Tag.swift
//  Persistence
//
//  Created by Emilio Peláez on 4/10/26.
//

import CoreData

@objc(Tag)
public class Tag: NSManagedObject {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<Tag> {
		NSFetchRequest<Tag>(entityName: "Tag")
	}
	
	@NSManaged public var name: String?
	@NSManaged public var items: NSSet?
}

public extension Tag {
	@objc(addItemsObject:)
	@NSManaged func addToItems(_ value: StoredItem)
	
	@objc(removeItemsObject:)
	@NSManaged func removeFromItems(_ value: StoredItem)
	
	@objc(addItems:)
	@NSManaged func addToItems(_ values: NSSet)
	
	@objc(removeItems:)
	@NSManaged func removeFromItems(_ values: NSSet)
}

extension Tag: Identifiable {}

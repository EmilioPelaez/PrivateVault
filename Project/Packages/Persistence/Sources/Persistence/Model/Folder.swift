//
//  Folder.swift
//  Persistence
//
//  Created by Emilio Peláez on 4/10/26.
//

import CoreData

@objc(Folder)
public class Folder: NSManagedObject {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<Folder> {
		NSFetchRequest<Folder>(entityName: "Folder")
	}
	
	@NSManaged public var name: String?
	@NSManaged public var items: NSSet?
	@NSManaged public var parent: Folder?
	@NSManaged public var subfolders: NSSet?
}

public extension Folder {
	@objc(addItemsObject:)
	@NSManaged func addToItems(_ value: StoredItem)
	
	@objc(removeItemsObject:)
	@NSManaged func removeFromItems(_ value: StoredItem)
	
	@objc(addItems:)
	@NSManaged func addToItems(_ values: NSSet)
	
	@objc(removeItems:)
	@NSManaged func removeFromItems(_ values: NSSet)
	
	@objc(addSubfoldersObject:)
	@NSManaged func addToSubfolders(_ value: Folder)
	
	@objc(removeSubfoldersObject:)
	@NSManaged func removeFromSubfolders(_ value: Folder)
	
	@objc(addSubfolders:)
	@NSManaged func addToSubfolders(_ values: NSSet)
	
	@objc(removeSubfolders:)
	@NSManaged func removeFromSubfolders(_ values: NSSet)
}

extension Folder: Identifiable {}

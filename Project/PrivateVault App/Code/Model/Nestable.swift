//
//  Nestable.swift
//  PrivateVault
//
//  Created by Elena Meneghini on 11/08/2021.
//

protocol Nestable {
	func belongs(to folder: Folder) -> Bool
	func canBelong(to folder: Folder) -> Bool
	func add(to folder: Folder)
	func remove(from folder: Folder)
}

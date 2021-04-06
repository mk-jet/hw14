//
//  CoreDataTasks+CoreDataProperties.swift
//  hw14
//
//  Created by Maksim Komolikov on 06.04.2021.
//
//

import Foundation
import CoreData


extension CoreDataTasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataTasks> {
        return NSFetchRequest<CoreDataTasks>(entityName: "CoreDataTasks")
    }

    @NSManaged public var name: String?
    @NSManaged public var completeness: Bool

}

extension CoreDataTasks : Identifiable {

}

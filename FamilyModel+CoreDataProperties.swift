//
//  FamilyModel+CoreDataProperties.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/22.
//
//

import Foundation
import CoreData


extension FamilyModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FamilyModel> {
        return NSFetchRequest<FamilyModel>(entityName: "FamilyModel")
    }

    @NSManaged public var familyId: UUID?
    @NSManaged public var familyMemberCount: Int64
    @NSManaged public var familyName: String?
    @NSManaged public var familyTree: Int16

}

extension FamilyModel : Identifiable {

}

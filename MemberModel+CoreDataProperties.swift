//
//  MemberModel+CoreDataProperties.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/22.
//
//

import Foundation
import CoreData


extension MemberModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemberModel> {
        return NSFetchRequest<MemberModel>(entityName: "MemberModel")
    }

    @NSManaged public var appleId: String?
    @NSManaged public var avatar: String?
    @NSManaged public var birthday: String?
    @NSManaged public var familyId: UUID?
    @NSManaged public var familyStatus: String?
    @NSManaged public var missCard: Int64
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var status: String?

}

extension MemberModel : Identifiable {

}

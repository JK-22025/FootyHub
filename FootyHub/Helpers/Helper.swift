//
//  Helper.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-03-31.
//
import CoreData

extension NSManagedObjectContext{
    func fetchByUUID<T: NSManagedObject>(_ entityClass: T.Type, id: UUID) -> T? {
        let request = T.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        do{
            return try self.fetch(request).first as? T
        }catch{
            print("Error fetching by id: \(error.localizedDescription)")
            return nil
        }
    }
}

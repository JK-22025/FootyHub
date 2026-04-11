//
//  FirebaseSync.swift
//  FootyHub
//
//  Created by Jawad Kazan on 2026-03-10.
//

import Foundation
import FirebaseFirestore
import CoreData

// local ---> remote (firebase)




// remote ---> local

// loop -> local ---> remote --> local ---> remote

// fetch ---> date (current)

final class FirebaseSync{
    private let db = Firestore.firestore()
    private var listenter: ListenerRegistration?
    private let collectionPath: String
    
    init(collectionPath: String = "matches"){
        self.collectionPath = collectionPath
    }
    
    //de-init
    deinit{
        listenter?.remove()
    }
    
    func StopListening(){
        listenter?.remove()
        listenter = nil
    }
    
    func startListeningForDay(
        date: Date,
        calendar: Calendar,
        context: NSManagedObjectContext,
        onApplyingRemote: @escaping (Bool) -> Void,
        onRemoteApplied: @escaping () -> Void
    ){
        // remove any and all old listners
        StopListening()
        
        // start, end date
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        
        //custom firebase query to fetch based on the start --- end
        let query = db.collection(collectionPath)
            .whereField("createdAt", isGreaterThan: start)
            .whereField("createdAt", isLessThan: end)
        listenter = query.addSnapshotListener{
            [weak self] snapshot, error in
            guard let self else {return}
            
            if let error{
                print("FireStore listen error:", error)
            }
            
            guard let snapshot else {return}
            
            DispatchQueue.main.async {
                onApplyingRemote(true)
            }
            context.perform {
                for changes in snapshot.documentChanges{
                    let doc = changes.document
                    let docID = doc.documentID
                    switch changes.type{
                    case .added, .modified:
                        self.upsert(
                            docID: docID,
                            data: doc.data(),
                            into: context
                        )
                    case .removed:
                        self.delete(
                            docID: docID,
                            from: context
                        )
                        
                    }
                }
                do{
                    try context.save()
                }catch{
                    print("Coredata error: ", error)
                }
                
                //toggle remote applied
                DispatchQueue.main.async {
                    onApplyingRemote(false)
                    onRemoteApplied()
                }
            }
        }
    }
    
    
    func pushUpsert(match: Match){
        guard let id = match.id?.uuidString else{return}
        let ref = db.collection(collectionPath).document(id)
        ref.setData(serialize(match: match), merge: true)
    }
    
    func pushUpsert(player: Player) {
        guard let id = player.id?.uuidString else { return }
        let ref = db.collection("players").document(id)
        ref.setData(serialize(player: player), merge: true)
    }
    
    func pushUpsert(team: Team) {
        guard let id = team.id?.uuidString else { return }
        let ref = db.collection("teams").document(id)
        ref.setData(serialize(team: team), merge: true)
    }
    
    func pushUpsert(league: League) {
        guard let id = league.id?.uuidString else { return }
        let ref = db.collection("leagues").document(id)
        ref.setData(serialize(league: league), merge: true)
    }
    
    func pushUpsert(stadium: Stadium) {
        guard let id = stadium.id?.uuidString else { return }
        let ref = db.collection("stadiums").document(id)
        ref.setData(serialize(stadium: stadium), merge: true)
    }
    
    func pushUpsert(geo: Geo) {
        guard let id = geo.id?.uuidString else { return }
        let ref = db.collection("geos").document(id)
        ref.setData(serialize(geo: geo), merge: true)
    }
    
    func pushUpsert(settings: Settings) {
        guard let id = settings.id?.uuidString else { return }
        let ref = db.collection("settings").document(id)
        ref.setData(serialize(settings: settings), merge: true)
    }
    
    func pushUpsert(user: User) {
        guard let id = user.id?.uuidString else { return }
        let ref = db.collection("users").document(id)
        ref.setData(serialize(user: user), merge: true)
    }
    
    private func upsert(
        docID: String,
        data: [String: Any],
        into context: NSManagedObjectContext
        
    ){
        guard let uuid = UUID(uuidString: docID) else {return}
        let req: NSFetchRequest<Match> = Match.fetchRequest()
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        // if present ignore if not create a s
        let match = (try? context.fetch(req).first) ?? Match(context: context)
        match.id = uuid
        match.createdAt = data["createdAt"] as? Date
        match.awayScore = Int64(data["awayScore"] as? Int ?? 0)
        match.homeScore = Int64(data["homeScore"] as? Int ?? 0)
        match.stadium = data["stadium"] as? String
        
        if let TS = data["createdAt"] as? Timestamp {
            match.createdAt = TS.dateValue()
        }else if let d = data["createdAt"] as? Date{
            match.createdAt = d
            
        }else{
            match.createdAt = nil
        }
        
        
        
        
        
    }
    


    
//MARK: delete
    
    private func delete(
        docID: String,
        from context: NSManagedObjectContext
    ){
        guard let uuid = UUID(uuidString: docID) else {return}
        let req: NSFetchRequest<Match> = Match.fetchRequest()
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        if let match = try? context.fetch(req).first{
            context.delete(match)
        }
    }
    
    func pushDelete(matchID: UUID){
        db.collection(collectionPath).document(matchID.uuidString).delete()
    }
    
    func pushDelete(userID: UUID){
        db.collection(collectionPath).document(userID.uuidString).delete()
    }
    
    
    private func serialize(match: Match) -> [String: Any]{
        var out: [String: Any] = [
            "stadium": match.stadium ?? "",
            "createdAt": match.createdAt ?? Date(),
            "homeScore": match.homeScore,
            "awayScore": match.awayScore,
        ]
        
        
        
        return out
    }
    
    private func serialize(player: Player)-> [String: Any] {
        var out: [String: Any] = [
            "name": player.name ?? "",
            "nationality": player.nationality ?? "",
            "position": player.position ?? "",
            "team": player.team ?? "",
            "photoURL": player.photoURL ?? "",
            "birthDay": player.brithDate ?? Date(),
            "height": player.height,
            "weight": player.weight,
            "stats": player.stats,
            "rating": player.rating
            
        ]
        
        if let completed = player.brithDate{
            out["completedDate"] = completed
        }else{
            out["completedDate"] = FieldValue.delete()
        }
        
        return out
        
        
        
        
    }
    private func serialize(team: Team)-> [String: Any] {
        var out: [String: Any] = [
            "name": team.name ?? "",
            "coach": team.coach ?? "",
            "description": team.descrption ?? "",
            "logoURL": team.logoURL ?? "",
            "foundedYear": team.foundedYear ?? Date(),
            "stats": team.stats
            
            
            
            
            
        ]
        
        return out
    }
    
    private func serialize(league: League)-> [String: Any] {
        var out: [String: Any] = [
            "country": league.country ?? "",
            "name": league.name ?? ""
            ]
        return out
        
            
    }
    
    private func serialize(stadium: Stadium)-> [String: Any]{
        var out: [String: Any] = [
            "city": stadium.city ?? "",
            "name": stadium.name ?? "",
            "team": stadium.team ?? "",
            "capacity": stadium.capacity,
            "imageURL": stadium.imageURL ?? "",
            "country": stadium.country ?? ""
            
        ]
        return out
    }
    
    private func serialize(geo: Geo)-> [String: Any] {
        var out: [String: Any] = [
            "lat": geo.latitude,
            "long": geo.longitude
        ]
        return out
    }
    
    private func serialize(settings: Settings)-> [String: Any]{
        var out: [String: Any] = [
            "profile": settings.profile ?? "",
            "profileImage": settings.profileImage ?? ""
        ]
        return out
    }
    
    private func serialize(user: User)-> [String: Any]{
        var out: [String: Any] = [
            "displayName": user.displayName ?? "",
            "email": user.email ?? "",
            "passwordHash": user.passwordHash ?? "",
            "profileimageURL": user.profileImageURL ?? ""
        ]
        return out
    }
}



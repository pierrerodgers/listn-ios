//
//  ListViewModel.swift
//  listn
//
//  Created by Pierre Rodgers on 23/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewModel: ObservableObject {
    
    //@Published var albums : Results<album>
    var app : RealmApp
    
    init(app: RealmApp) {
        //albums = Results<album>(RlmResul)
        self.app = app
        updateAlbums()
        //self.updateAlbums()
    }
    
    func updateAlbums() {
        app.login(withCredential: AppCredentials.anonymous(), completion: {(user, error) in
            /*Realm.asyncOpen(configuration: user!.configuration(partitionValue: "PUBLIC"), callback: { maybeRealm, error in
                guard error == nil else {
                    fatalError(error.debugDescription)
                }
                guard let realm = maybeRealm else {
                    fatalError("failed")
                }
                let albums = realm.objects(review.self)
                print(albums)
                print(realm)
                
                
            })*/
            let realm = try! Realm(configuration: user!.configuration(partitionValue: "PUBLIC"))
            print(realm.objects(Artist.self))
            /*do {
                let realm = try Realm(configuration: user!.configuration(partitionValue: "PUBLIC"))
                print(realm.objects(album.self))
            }
            catch (error) {
                print(error)
            }*/
            return
        })
        
    }
    
    
}

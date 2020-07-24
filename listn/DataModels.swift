//
//  DataModels.swift
//  listn
//
//  Created by Pierre Rodgers on 23/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import Foundation
import RealmSwift

class Album: Object, Identifiable {
    @objc dynamic var _id: ObjectId? = nil
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var artist: Artist?
    @objc dynamic var artwork: String? = nil
    let genres = RealmSwift.List<String>()
    @objc dynamic var name: String? = nil
    @objc dynamic var recordLabel: String? = nil
    @objc dynamic var releaseDate: Date? = nil
    @objc dynamic var streamingUrls: album_streamingUrls?
    override static func primaryKey() -> String? {
        return "_id"
    }
}


class album_streamingUrls: EmbeddedObject {
    @objc dynamic var appleMusic: String? = nil
    @objc dynamic var spotify: String? = nil
}

class Artist: Object {
    @objc dynamic var _id: ObjectId? = nil
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var image: String? = nil
    @objc dynamic var name: String? = nil
    @objc dynamic var streamingUrls: artist_streamingUrls?
    override static func primaryKey() -> String? {
        return "_id"
    }
}

class artist_streamingUrls: EmbeddedObject {
    @objc dynamic var appleMusic: String? = nil
    @objc dynamic var spotify: String? = nil
}


class Reviewer: Object {
    @objc dynamic var _id: ObjectId? = nil
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var link: String? = nil
    @objc dynamic var name: String? = nil
    override static func primaryKey() -> String? {
        return "_id"
    }
}

class Review: Object, Identifiable {
    //@objc dynamic var _id: ObjectId? = nil
    var _id: ObjectId? = nil
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var album: Album?
    @objc dynamic var artist: Artist?
    @objc dynamic var date: Date? = nil
    @objc dynamic var link: String? = nil
    @objc dynamic var reviewer: Reviewer?
    @objc dynamic var score: String? = nil
    override static func primaryKey() -> String? {
        return "_id"
    }
}

class User:Object {
    @objc dynamic var _id: ObjectId? = nil
}

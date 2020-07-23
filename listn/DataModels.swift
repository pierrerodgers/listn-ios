//
//  DataModels.swift
//  listn
//
//  Created by Pierre Rodgers on 23/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import Foundation
import RealmSwift

class album: Object {
    @objc dynamic var _id: ObjectId? = nil
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var artist: artist?
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

class artist: Object {
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


class reviewer: Object {
    @objc dynamic var _id: ObjectId? = nil
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var link: String? = nil
    @objc dynamic var name: String? = nil
    override static func primaryKey() -> String? {
        return "_id"
    }
}

class review: Object {
    @objc dynamic var _id: ObjectId? = nil
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var album: album?
    @objc dynamic var artist: artist?
    @objc dynamic var date: Date? = nil
    @objc dynamic var link: String? = nil
    @objc dynamic var reviewer: reviewer?
    @objc dynamic var score: String? = nil
    override static func primaryKey() -> String? {
        return "_id"
    }
}


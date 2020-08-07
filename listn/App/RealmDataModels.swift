import Foundation
import RealmSwift


class Album: Object {
    @objc dynamic var _id: ObjectId? = nil
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var artist: Artist?
    @objc dynamic var artwork: String? = nil
    let genres = RealmSwift.List<String>()
    @objc dynamic var name: String? = nil
    @objc dynamic var recordLabel: String? = nil
    @objc dynamic var releaseDate: Date? = nil
    @objc dynamic var streamingUrls: Album_streamingUrls?
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(listnAlbum: ListnAlbum) {
        self.init()
        _id = try! ObjectId(string:listnAlbum._id)
    }
}





class Album_streamingUrls: EmbeddedObject {
    @objc dynamic var appleMusic: String? = nil
    @objc dynamic var spotify: String? = nil
}





class Artist: Object {
    @objc dynamic var _id: ObjectId? = nil
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var image: String? = nil
    @objc dynamic var name: String? = nil
    @objc dynamic var streamingUrls: Artist_streamingUrls?
    override static func primaryKey() -> String? {
        return "_id"
    }
}





class Artist_streamingUrls: EmbeddedObject {
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





class Review: Object {
    @objc dynamic var _id: ObjectId? = nil
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





class User: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var name: String = ""
    @objc dynamic var user_id: String = ""
    override static func primaryKey() -> String? {
        return "_id"
    }
}





class UserReview: Object {
    @objc dynamic var _id: ObjectId? = ObjectId.generate()
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var album_id : ObjectId? = nil
    @objc dynamic var score: String? = nil
    @objc dynamic var text: String? = nil
    @objc dynamic var user: User? = nil
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(listnUserReview:ListnUserReview, partitionKey:String, user: User) {
        self.init()
        self._partitionKey = partitionKey
        self.album_id = try! ObjectId(string:listnUserReview.album._id)
        self.score = listnUserReview.score
        self.text = listnUserReview.text ?? ""
        self.user = user
    }
}





class ArtistFollow: Object {
    @objc dynamic var _id: ObjectId? = nil
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var artistFollowed: Artist?
    @objc dynamic var user: User?
    override static func primaryKey() -> String? {
        return "_id"
    }
}





class UserFollow: Object {
    @objc dynamic var _id: ObjectId? = nil
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var user: User?
    @objc dynamic var userFollowed: User?
    override static func primaryKey() -> String? {
        return "_id"
    }
}





class ReviewerFollow: Object {
    @objc dynamic var _id: ObjectId? = ObjectId.generate()
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var reviewerFollowed_id : ObjectId? = nil
    @objc dynamic var user: User?
    override static func primaryKey() -> String? {
        return "_id"
    }
}





class ReviewLike: Object {
    @objc dynamic var _id: ObjectId? = nil
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var review_liked: Review?
    @objc dynamic var user: User?
    override static func primaryKey() -> String? {
        return "_id"
    }
}





class UserReviewLiked: Object {
    @objc dynamic var _id: ObjectId? = nil
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var user: User?
    @objc dynamic var userReviewLiked: UserReview?
    override static func primaryKey() -> String? {
        return "_id"
    }
}





class UserFeed: Object {
    @objc dynamic var _id: ObjectId? = nil
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var date: Date? = nil
    let reviews = RealmSwift.List<UserFeed_reviews>()
    @objc dynamic var user: ObjectId? = nil
    override static func primaryKey() -> String? {
        return "_id"
    }
}





class UserFeed_reviews: EmbeddedObject {
    @objc dynamic var date: Date? = nil
    @objc dynamic var id: String? = nil
    @objc dynamic var type: String? = nil
}


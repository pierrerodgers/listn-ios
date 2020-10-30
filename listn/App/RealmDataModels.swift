import Foundation
import RealmSwift


class Review: Object {
    @objc dynamic var _id: ObjectId? = ObjectId.generate()
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var album: ObjectId? = nil
    @objc dynamic var artist: ObjectId? = nil
    @objc dynamic var date: Date? = nil
    @objc dynamic var user: ObjectId? = nil
    @objc dynamic var score: String? = nil
    @objc dynamic var text: String? = nil
    
    init(listnReview:ListnReview, partitionKey:String) {
        self.album = try! ObjectId(string: listnReview.album._id)
        self.artist = try! ObjectId(string: listnReview.album.artist._id)
        self.date = listnReview.date
        self.user = try! ObjectId(string:listnReview.user._id)
        self.score = listnReview.score
        self._partitionKey = partitionKey
        self.text = listnReview.text
    }
    
    override required init() {
        
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
class UserFollow: Object {
    @objc dynamic var _id: ObjectId? = ObjectId.generate()
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var user: ObjectId? = nil
    @objc dynamic var userFollowed: ObjectId? = nil
    override static func primaryKey() -> String? {
        return "_id"
    }
}

class ReviewLike: Object {
    @objc dynamic var _id: ObjectId? = ObjectId.generate()
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var reviewLiked: ObjectId? = nil
    @objc dynamic var user: ObjectId? = nil
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

class User: Object {
    @objc dynamic var _id: ObjectId? = nil
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var link: String? = nil
    @objc dynamic var name: String? = nil
    @objc dynamic var user_id: String? = nil
    @objc dynamic var username: String? = nil
    override static func primaryKey() -> String? {
        return "_id"
    }
}

class ReviewComment: Object {
    init(listnComment:ListnComment, partitionKey:String) {
        self.user = try! ObjectId(string:listnComment.user)
        self.commentText = listnComment.commentText
        self._partitionKey = partitionKey
        self.reviewCommented = try! ObjectId(string:listnComment.reviewCommented)
    }
    override required init() {
        
    }
    
    
    @objc dynamic var _id: ObjectId? = ObjectId.generate()
    @objc dynamic var _partitionKey: String? = nil
    @objc dynamic var commentText: String? = nil
    @objc dynamic var reviewCommented: ObjectId? = nil
    @objc dynamic var user: ObjectId? = nil
    override static func primaryKey() -> String? {
        return "_id"
    }
}

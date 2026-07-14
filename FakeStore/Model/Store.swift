import Foundation

struct Store : Decodable {
    
    let products : [Product]
    
}

struct Product : Decodable {
    let id : Int
    let title : String
    let description : String
    let category : String
    let price : Float
    let discountPercentage : Float
    let rating : Float
    let stock : Int
    let brand : String?
    let weight : Float
    let dimensions : Dimensions
    let warrantyInformation : String
    let shippingInformation : String
    let availabilityStatus : String
    let reviews : [Review]
    let returnPolicy : String
    let minimumOrderQuantity : Int
    let meta : Meta
    let images : [String]
    let thumbnail : String
}

struct Dimensions : Decodable {
    let width : Float
    let height : Float
    let depth : Float
}

struct Review : Decodable {
    let rating : Int
    let comment : String
    let date : String
    let reviewerName : String
    let reviewerEmail : String
}

struct Meta : Decodable {
    let createdAt : String
    let updatedAt : String
    let barcode : String
    let qrCode : String
}


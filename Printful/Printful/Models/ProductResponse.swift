//
//  ProductResponse.swift
//  Printful
//
//  Created by Armands Berzins on 11/04/2023.
//

import Foundation

// MARK: - ProductResponse
struct ProductResponse: Codable {
    let code: Int
    let result: [Product]
}

// MARK: - ProductResult
struct Product: Codable, Identifiable {
    let id, mainCategoryID: Int
    let type, description, typeName, title: String?
    let brand: String?
    let model: String?
    let image: String?
    let variantCount: Int?
    let currency: Currency?
    let options: [ResultOption]?
    let dimensions: Dimensions?
    let isDiscontinued: Bool?
    let avgFulfillmentTime: Int?
    let techniques: [Technique]?
    let files: [File]?
    let originCountry: String?
    var isFavorite = false

    enum CodingKeys: String, CodingKey {
        case id
        case mainCategoryID = "main_category_id"
        case type, description
        case typeName = "type_name"
        case title, brand, model, image
        case variantCount = "variant_count"
        case currency, options, dimensions
        case isDiscontinued = "is_discontinued"
        case avgFulfillmentTime = "avg_fulfillment_time"
        case techniques, files
        case originCountry = "origin_country"
    }
}

enum Currency: String, Codable {
    case usd = "USD"
}

// MARK: - Dimensions
struct Dimensions: Codable {
    let dimensionsDefault, xs, s, m: String?
    let l, xl, the2Xl, the3Xl: String?
    let the1212, the1216, the16X16, the1620: String?
    let the1824, the2436, the810, the10X10: String?
    let the1218, the1414, the1616, the1818: String?
    let front, side, the11Oz, the15Oz: String?

    enum CodingKeys: String, CodingKey {
        case dimensionsDefault = "default"
        case xs = "XS"
        case s = "S"
        case m = "M"
        case l = "L"
        case xl = "XL"
        case the2Xl = "2XL"
        case the3Xl = "3XL"
        case the1212 = "12×12"
        case the1216 = "12×16"
        case the16X16 = "16x16"
        case the1620 = "16×20"
        case the1824 = "18×24"
        case the2436 = "24×36"
        case the810 = "8×10"
        case the10X10 = "10x10"
        case the1218 = "12×18"
        case the1414 = "14×14"
        case the1616 = "16×16"
        case the1818 = "18×18"
        case front, side
        case the11Oz = "11oz"
        case the15Oz = "15oz"
    }
}

// MARK: - File
struct File: Codable {
    let id, type, title: String
    let additionalPrice: String?
    let options: [FileOption]

    enum CodingKeys: String, CodingKey {
        case id, type, title
        case additionalPrice = "additional_price"
        case options
    }
}

// MARK: - FileOption
struct FileOption: Codable {
    let id: PurpleID
    let type: TypeEnum
    let title: PurpleTitle
    let additionalPrice: Double

    enum CodingKeys: String, CodingKey {
        case id, type, title
        case additionalPrice = "additional_price"
    }
}

enum PurpleID: String, Codable {
    case fullColor = "full_color"
}

enum PurpleTitle: String, Codable {
    case unlimitedColor = "Unlimited color"
}

enum TypeEnum: String, Codable {
    case bool = "bool"
    case multiSelect = "multi_select"
    case radio = "radio"
    case text = "text"
}

// MARK: - ResultOption
struct ResultOption: Codable {
    let id: FluffyID
    let title: FluffyTitle
    let type: TypeEnum
    let values: ValuesUnion
    let additionalPrice: String?

    enum CodingKeys: String, CodingKey {
        case id, title, type, values
        case additionalPrice = "additional_price"
    }
}

// MARK: - AdditionalPriceBreakdownClass
struct AdditionalPriceBreakdownClass: Codable {
    let flat, the3D, both: String

    enum CodingKeys: String, CodingKey {
        case flat
        case the3D = "3d"
        case both
    }
}

enum FluffyID: String, Codable {
    case embroideryType = "embroidery_type"
    case insidePocket = "inside_pocket"
    case lifelike = "lifelike"
    case notes = "notes"
    case stitchColor = "stitch_color"
    case threadColors = "thread_colors"
    case threadColors3D = "thread_colors_3d"
    case threadColorsApparel = "thread_colors_apparel"
    case threadColorsApparelBack = "thread_colors_apparel_back"
    case threadColorsBack = "thread_colors_back"
    case threadColorsChestCenter = "thread_colors_chest_center"
    case threadColorsChestLeft = "thread_colors_chest_left"
    case threadColorsChestTopLeft = "thread_colors_chest_top_left"
    case threadColorsCornerLeft = "thread_colors_corner_left"
    case threadColorsCornerRight = "thread_colors_corner_right"
    case threadColorsInsideLeft = "thread_colors_inside_left"
    case threadColorsInsideRight = "thread_colors_inside_right"
    case threadColorsLeft = "thread_colors_left"
    case threadColorsOutline = "thread_colors_outline"
    case threadColorsOutsideLeft = "thread_colors_outside_left"
    case threadColorsOutsideRight = "thread_colors_outside_right"
    case threadColorsPatchFront = "thread_colors_patch_front"
    case threadColorsRight = "thread_colors_right"
    case threadColorsSleeveLeftTop = "thread_colors_sleeve_left_top"
    case threadColorsSleeveRightTop = "thread_colors_sleeve_right_top"
    case threadColorsWristLeft = "thread_colors_wrist_left"
    case threadColorsWristRight = "thread_colors_wrist_right"
}

enum FluffyTitle: String, Codable {
    case addInsidePocket = "Add inside pocket?"
    case apparelBackThreadColors = "Apparel back thread colors"
    case backThreadColors = "Back thread colors"
    case centerChestThreadColors = "Center chest thread colors"
    case drawcordStitchColor = "Drawcord & Stitch color"
    case embroideryNotes = "Embroidery notes"
    case embroideryType = "Embroidery type"
    case flatThreadColors = "Flat thread colors"
    case leftChestThreadColors = "Left chest thread colors"
    case leftCornerThreadColors = "Left corner thread colors"
    case leftInsideThreadColors = "Left inside thread colors"
    case leftOutsideThreadColors = "Left outside thread colors"
    case leftSideThreadColors = "Left side thread colors"
    case lifelike = "Lifelike"
    case outlineColor = "Outline color"
    case patchFrontThreadColors = "Patch front thread colors"
    case printingNotes = "Printing notes"
    case rightCornerThreadColors = "Right corner thread colors"
    case rightInsideThreadColors = "Right inside thread colors"
    case rightOutsideThreadColors = "Right outside thread colors"
    case rightSideThreadColors = "Right side thread colors"
    case sleeveLeftTopThreadColors = "Sleeve left top thread colors"
    case sleeveRightTopThreadColors = "Sleeve right top thread colors"
    case stitchColor = "Stitch color"
    case the3DPuffThreadColors = "3D Puff thread colors"
    case topLeftChestThreadColors = "Top left chest thread colors"
    case wristLeftThreadColors = "Wrist left thread colors"
    case wristRightThreadColors = "Wrist right thread colors"
    case zipperStitchColor = "Zipper & Stitch color"
}

enum ValuesUnion: Codable {
    case stringArray([String])
    case valuesClass(ValuesClass)
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .stringArray(x)
            return
        }
        if let x = try? container.decode(ValuesClass.self) {
            self = .valuesClass(x)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        throw DecodingError.typeMismatch(ValuesUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ValuesUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .stringArray(let x):
            try container.encode(x)
        case .valuesClass(let x):
            try container.encode(x)
        case .null:
            try container.encodeNil()
        }
    }
}

// MARK: - ValuesClass
struct ValuesClass: Codable {
    let ffffff: Ffffff?
    let the000000: The000000?
    let the96A1A8: The96A1A8?
    let a67843: A67843?
    let ffcc00: Ffcc00?
    let e25C27: E25C27?
    let cc3366: Cc3366?
    let cc3333: Cc3333?
    let the660000: The660000?
    let the333366: The333366?
    let the005397: The005397?
    let the3399Ff: The3399Ff?
    let the6B5294: The6B5294?
    let the01784E: The01784E?
    let the7Ba35A: The7Ba35A?
    let black: Black?
    let clear: String?
    let white: White?
    let flat: Flat?
    let the3D: The3D?
    let both: Both?

    enum CodingKeys: String, CodingKey {
        case ffffff = "#FFFFFF"
        case the000000 = "#000000"
        case the96A1A8 = "#96A1A8"
        case a67843 = "#A67843"
        case ffcc00 = "#FFCC00"
        case e25C27 = "#E25C27"
        case cc3366 = "#CC3366"
        case cc3333 = "#CC3333"
        case the660000 = "#660000"
        case the333366 = "#333366"
        case the005397 = "#005397"
        case the3399Ff = "#3399FF"
        case the6B5294 = "#6B5294"
        case the01784E = "#01784E"
        case the7Ba35A = "#7BA35A"
        case black, clear, white, flat
        case the3D = "3d"
        case both
    }
}

enum A67843: String, Codable {
    case the1672OldGold = "1672 Old Gold"
}

enum Black: String, Codable {
    case black = "Black"
}

enum Both: String, Codable {
    case partial3DPuff150 = "Partial 3D Puff (+$1.50)"
}

enum Cc3333: String, Codable {
    case the1839Red = "1839 Red"
}

enum Cc3366: String, Codable {
    case the1910Flamingo = "1910 Flamingo"
}

enum E25C27: String, Codable {
    case the1987Orange = "1987 Orange"
}

enum Ffcc00: String, Codable {
    case the1951Gold = "1951 Gold"
}

enum Ffffff: String, Codable {
    case the1801White = "1801 White"
}

enum Flat: String, Codable {
    case flatEmbroidery = "Flat Embroidery"
}

enum The000000: String, Codable {
    case the1800Black = "1800 Black"
}

enum The005397: String, Codable {
    case the1842Royal = "1842 Royal"
}

enum The01784E: String, Codable {
    case the1751KellyGreen = "1751 Kelly Green"
}

enum The333366: String, Codable {
    case the1966Navy = "1966 Navy"
}

enum The3399Ff: String, Codable {
    case the1695AquaTeal = "1695 Aqua/Teal"
}

enum The3D: String, Codable {
    case the3DPuff150 = "3D Puff (+$1.50)"
}

enum The660000: String, Codable {
    case the1784Maroon = "1784 Maroon"
}

enum The6B5294: String, Codable {
    case the1832Purple = "1832 Purple"
}

enum The7Ba35A: String, Codable {
    case the1848KiwiGreen = "1848 Kiwi Green"
}

enum The96A1A8: String, Codable {
    case the1718Grey = "1718 Grey"
}

enum White: String, Codable {
    case white = "White"
}

// MARK: - Technique
struct Technique: Codable {
    let key: Key
    let displayName: DisplayName
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case key
        case displayName = "display_name"
        case isDefault = "is_default"
    }
}

enum DisplayName: String, Codable {
    case cutSewSublimation = "Cut & sew sublimation"
    case digitalPrinting = "Digital printing"
    case directToFilm = "Direct to Film"
    case dtgPrinting = "DTG printing"
    case embroidery = "Embroidery"
    case sublimation = "Sublimation"
    case uvPrinting = "UV printing"
}

enum Key: String, Codable {
    case cutSew = "CUT-SEW"
    case digital = "DIGITAL"
    case dtfilm = "DTFILM"
    case dtg = "DTG"
    case embroidery = "EMBROIDERY"
    case sublimation = "SUBLIMATION"
    case uv = "UV"
}

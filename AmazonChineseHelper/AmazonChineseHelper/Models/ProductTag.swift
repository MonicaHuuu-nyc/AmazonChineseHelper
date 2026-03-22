import Foundation

enum TagStyle: String, Codable {
    case popular    // 人气之选
    case premium    // 高端旗舰
    case highTech   // 高科技
    case value      // 性价比高
    case bundle     // 超值套装
    case kids       // 育儿推荐
    case basic      // 基础用
}

struct ProductTag: Codable, Identifiable, Hashable {
    let label: String
    let style: TagStyle

    var id: String { label }
}

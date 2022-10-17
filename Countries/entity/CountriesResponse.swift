import Foundation

// MARK: - CountriesResponse
class CountriesResponse: Codable {
    var data: [Country]
    var links: [Link]
    var metadata: Metadata

    init(data: [Country], links: [Link], metadata: Metadata) {
        self.data = data
        self.links = links
        self.metadata = metadata
    }
}

// MARK: - Country
class Country: Codable, Equatable {
    var code: String
    var currencyCodes: [String]
    var name, wikiDataId: String

    init(code: String, currencyCodes: [String], name: String, wikiDataId: String) {
        self.code = code
        self.currencyCodes = currencyCodes
        self.name = name
        self.wikiDataId = wikiDataId
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.wikiDataId == rhs.wikiDataId
    }
}

// MARK: - Link
class Link: Codable {
    var rel, href: String

    init(rel: String, href: String) {
        self.rel = rel
        self.href = href
    }
}

// MARK: - Metadata
class Metadata: Codable {
    var currentOffset, totalCount: Int

    init(currentOffset: Int, totalCount: Int) {
        self.currentOffset = currentOffset
        self.totalCount = totalCount
    }
}

import Foundation

// MARK: - CountryDetailResponse
class CountryDetailResponse: Codable {
    var data: CountryDetail

    init(data: CountryDetail) {
        self.data = data
    }
}

// MARK: - CountryDetail
class CountryDetail: Codable {
    var capital, code, callingCode: String?
    var currencyCodes: [String]?
    var flagImageUri: String
    var name: String?
    var numRegions: Int?
    var wikiDataId: String?

    init(capital: String, code: String, callingCode: String, currencyCodes: [String], flagImageUri: String, name: String, numRegions: Int, wikiDataId: String) {
        self.capital = capital
        self.code = code
        self.callingCode = callingCode
        self.currencyCodes = currencyCodes
        self.flagImageUri = flagImageUri
        self.name = name
        self.numRegions = numRegions
        self.wikiDataId = wikiDataId
    }
}

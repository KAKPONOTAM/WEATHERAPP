import Foundation

extension String {
    var encodeUrl: Self {
        guard let changeToCyrillic = self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else { return "" }
        return changeToCyrillic
    }
}

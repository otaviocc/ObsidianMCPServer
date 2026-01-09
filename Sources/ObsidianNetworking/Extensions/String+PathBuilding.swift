import Foundation

extension String {

    func appendingPeriodicPath(
        year: Int? = nil,
        month: Int? = nil,
        day: Int? = nil
    ) -> String {
        guard let year,
              let month,
              let day
        else {
            return "/periodic/\(self)/"
        }

        let formattedMonth = String(format: "%02d", month)
        let formattedDay = String(format: "%02d", day)

        return "/periodic/\(self)/\(year)/\(formattedMonth)/\(formattedDay)/"
    }

    func appendedAsDirectoryToVaultPath() -> String {
        if isEmpty {
            return "/vault/"
        }

        return "/vault/\(self)/"
    }

    func appendedToVaultPath() -> String {
        "/vault/\(self)"
    }
}

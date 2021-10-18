import Foundation

enum ShortUUID {
    static func generate() -> String {
        return generate(from: UUID())
    }

    static func generate(from longUUID: UUID) -> String {
        var data = Data()

        let uuid = longUUID.uuid
        data.append(uuid.0)
        data.append(uuid.1)
        data.append(uuid.2)
        data.append(uuid.3)
        data.append(uuid.4)
        data.append(uuid.5)
        data.append(uuid.6)
        data.append(uuid.7)
        data.append(uuid.8)
        data.append(uuid.9)
        data.append(uuid.10)
        data.append(uuid.11)
        data.append(uuid.12)
        data.append(uuid.13)
        data.append(uuid.14)
        data.append(uuid.15)

        return data.base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }

    static func decode(_ shortUUID: String) -> String? {
        let base64 = (shortUUID + "==")
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        guard let data = Data(base64Encoded: base64) else { return nil }
        let uuid = UUID(
            uuid: (
                data[0], data[1], data[2], data[3],
                data[4], data[5], data[6], data[7],
                data[8], data[9], data[10], data[11],
                data[12], data[13], data[14], data[15]
            )
        )

        return uuid.uuidString
    }
}

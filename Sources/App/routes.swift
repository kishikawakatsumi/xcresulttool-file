import Vapor
import Foundation

func routes(_ app: Application) throws {
    app.get {  _ in healthCheck() }
    app.get("health") { _ in healthCheck() }

    func healthCheck() -> [String: String] { ["status": "pass"] }

    app.get("f") { (req) -> Response in
        guard let key = req.query[String.self, at: "k"] else { throw Abort(.badRequest) }

        let filepath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(key)
        guard let data = try? Data(contentsOf: filepath) else { throw Abort(.notFound) }

        return Response(
            status: .ok,
            headers: ["Content-Type": "image/png"],
            body: Response.Body(
                buffer: ByteBuffer(data: data)
            )
        )
    }

    app.get("file") { (req) -> Response in
        guard let key = req.query[String.self, at: "key"] else { throw Abort(.badRequest) }

        let filepath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(key)
        guard let data = try? Data(contentsOf: filepath) else { throw Abort(.notFound) }

        return Response(
            status: .ok,
            headers: ["Content-Type": "image/png"],
            body: Response.Body(
                buffer: ByteBuffer(data: data)
            )
        )
    }

    app.on(.POST, "file", body: .collect(maxSize: "100mb")) { (req) -> FileUploadResponse in
        guard let parameter = req.body.string else { throw Abort(.badRequest) }

        let filename = ShortUUID.generate()
        let filepath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)

        guard let data = Data(base64Encoded: parameter) else { throw Abort(.badRequest) }
        try data.write(to: filepath)

        return FileUploadResponse(link: "https://xcresulttool-file.herokuapp.com/f?k=\(filename)")
    }
}

struct FileUploadRequestParameter: Content {
    let file: String
}

struct FileUploadResponse: Content {
    let link: String
}

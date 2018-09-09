import Foundation

public class MP4BoxDumper {
  private let url: URL
  
  public init(url: URL) {
    self.url = url
  }
  
  public func dumpBox() {
    let stream = InputStream(url: url)!
    stream.open()
    dumpBox(stream: stream, indent: 0)
  }
  
  private func dumpBox(stream: InputStream, indent: Int) {
    var indent = indent
    while stream.hasBytesAvailable {
      let (size, _) = stream.read(maxLength: 4)
      let boxSize = size.uint32Value
      guard boxSize > 8 else { continue }
      let (type, _) = stream.read(maxLength: 4)
      guard let typeString = String(data: Data(bytes: type), encoding: .ascii) else { continue }
      let indentString = (0..<indent).map({ _ in " "}).reduce("", +)
      print("\(indentString)\(typeString)(\(boxSize))")
      let (data, _) = stream.read(maxLength: Int(boxSize - 8))
      
      switch typeString {
      case "moov", "trak", "mdia", "minf", "stbl", "edts",
           "mp4v", "s263", "avc1",
           "mp4a",
           "esds":
        indent += 1
        let nextInputStream = InputStream(data: Data(bytes: data))
        nextInputStream.open()
        dumpBox(stream: nextInputStream, indent: indent)
        indent -= 1
      default: break
      }
    }
  }
}

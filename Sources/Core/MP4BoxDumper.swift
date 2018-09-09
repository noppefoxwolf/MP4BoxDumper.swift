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
    stream.close()
  }
  
  private func dumpBox(stream: InputStream, indent: Int) {
    var indent = indent
    while stream.hasBytesAvailable {
      let (size, _) = stream.read(maxLength: 4)
      let boxSize = size.uint32Value
      guard boxSize > 8 else { continue }
      guard let typeString = stream.readAsciiString(length: 4) else { return }
      let indentString = (0..<indent).map({ _ in " "}).reduce("", +)
      print("\(indentString)\(typeString)(\(boxSize))")
      let (data, _) = stream.read(maxLength: Int(boxSize - 8))
      
      switch typeString {
      case "ftyp":
        dumpftyp(data: Data(bytes: data))
      case "moov", "trak", "mdia", "minf", "stbl", "edts",
           "mp4v", "s263", "avc1",
           "mp4a",
           "esds":
        indent += 1
        let nextInputStream = InputStream(data: Data(bytes: data))
        nextInputStream.open()
        dumpBox(stream: nextInputStream, indent: indent)
        indent -= 1
        nextInputStream.close()
      default: break
      }
    }
  }
  
  private func dumpftyp(data: Data) {
    let stream = InputStream(data: data)
    stream.open()
    if let major = stream.readAsciiString(length: 4) {
      print(" Major Brand: \(major)")
    }
    stream.skip(length: 4)
    while stream.hasBytesAvailable {
      if let comp = stream.readAsciiString(length: 4) {
        print(" Compatible Brand: \(comp)")
      }
    }
    stream.close()
  }
}

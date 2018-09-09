import Foundation
import Core

private func main(args: [String]) {
  let args = args.dropFirst()
  guard let filePath = args.first, !filePath.isEmpty else {
    print("ERROR: please input filepath")
    exit(1)
  }
  guard FileManager.default.fileExists(atPath: filePath) else {
    print("ERROR: not found file")
    exit(1)
  }
  let url = URL(fileURLWithPath: filePath)
  MP4BoxDumper(url: url).dumpBox()
}

main(args: CommandLine.arguments)

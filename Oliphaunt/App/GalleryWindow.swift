import AppKit
import SwiftUI
import Manfred

final class GalleryWindowManager {
    static let shared = GalleryWindowManager()

    private var windowController: GalleryWindowController?

    func show(media: [MediaAttachment], selectedAttachment: MediaAttachment) {
        windowController = GalleryWindowController(media: media, selectedAttachment: selectedAttachment)
        windowController?.showWindow(self)
        windowController?.window?.center()
    }
}

private final class GalleryWindowController: NSWindowController {
    convenience init(media: [MediaAttachment], selectedAttachment: MediaAttachment) {
        let rect = NSRect(origin: .zero, size: .init(width: 200, height: 200))
        let window = NSWindow(
            contentRect: rect,
            styleMask: [.resizable, .miniaturizable, .titled, .closable],
            backing: .buffered,
            defer: false,
            screen: .main
        )
        window.isMovableByWindowBackground = true
        window.contentView = NSHostingView(rootView: GalleryRoot(media: media, selectedAttachment: selectedAttachment))

        self.init(window: window)
    }
}

private struct GalleryRoot: View {
    let media: [MediaAttachment]
    let selectedAttachment: MediaAttachment

    var body: some View {
        imageItem(imageURL: selectedAttachment.url)
    }

    private func imageItem(imageURL: URL) -> some View {
        RemoteImageView(url: imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
                .controlSize(.small)
        }
        .frame(minWidth: 200, minHeight: 200)
    }
}

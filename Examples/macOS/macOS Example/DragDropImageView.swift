
import Foundation
import Cocoa

// https://stackoverflow.com/questions/11949250/how-to-resize-nsimage
extension NSImage {
    func resize(toSize: NSSize) -> NSImage? {
        let img = NSImage(size: toSize)
        let width = toSize.width
        let height = toSize.height

        if let ctx = NSGraphicsContext.current {
            img.lockFocus()
            ctx.imageInterpolation = .high
            self.draw(
                in: NSMakeRect(0, 0, width, height),
                from: NSMakeRect(0, 0, size.width, size.height),
                operation: .copy,
                fraction: 1
            )
            img.unlockFocus()
            return img
        }
        return nil
    }
}

// https://gist.github.com/raphaelhanneken/d77b6f9b01bef35709da
class DragDropImageView: NSImageView, NSDraggingSource {

    /// Holds the last mouse down event, to track the drag distance.
    var mouseDownEvent: NSEvent?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        // Assure editable is set to true, to enable drop capabilities.
        isEditable = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        // Assure editable is set to true, to enable drop capabilities.
        isEditable = true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    // MARK: - NSDraggingSource

    // Since we only want to copy/delete the current image we register ourselfes
    // for .Copy and .Delete operations.
    func draggingSession(_: NSDraggingSession, sourceOperationMaskFor _: NSDraggingContext) -> NSDragOperation {
        return NSDragOperation.copy.union(.delete)
    }

    // Clear the ImageView on delete operation; e.g. the image gets
    // dropped on the trash can in the dock.
    func draggingSession(_: NSDraggingSession, endedAt _: NSPoint, operation: NSDragOperation) {
        if operation == .delete {
            image = nil
        }
    }

    // Track mouse down events and safe the to the poperty.
    override func mouseDown(with theEvent: NSEvent) {
        mouseDownEvent = theEvent
    }

    // Track mouse dragged events to handle dragging sessions.
    override func mouseDragged(with theEvent: NSEvent) {
        // Get the image to drag
        guard let image = image else {
            return
        }
        // Calculate the drag distance...
        guard let mouseDown = mouseDownEvent?.locationInWindow else {
            return
        }
        let dragPoint = theEvent.locationInWindow
        let dragDistance = hypot(mouseDown.x - dragPoint.x, mouseDown.y - dragPoint.y)

        // ...to cancel the dragging session in case of accidental drag.
        if dragDistance < 3 {
            return
        }

        // Do some math to properly resize the given image.
        let size = NSSize(width: log10(image.size.width) * 30, height: log10(image.size.height) * 30)

        if let img = image.resize(toSize: size) {
            // Create a new NSDraggingItem with the image as content.
            let draggingItem = NSDraggingItem(pasteboardWriter: image)
            // Calculate the mouseDown location from the window's coordinate system to the ImageViews
            // coordinate system, to use it as origin for the dragging frame.
            let draggingFrameOrigin = convert(mouseDown, from: nil)
            // Build the dragging frame and offset it by half the image size on each axis
            // to center the mouse cursor within the dragging frame.
            let draggingFrame = NSRect(origin: draggingFrameOrigin, size: img.size).offsetBy(
                dx: -img.size.width / 2, dy: -img.size.height / 2
            )

            // Assign the dragging frame to the draggingFrame property of our dragging item.
            draggingItem.draggingFrame = draggingFrame

            // Provide the components of the dragging image.
            draggingItem.imageComponentsProvider = {
                let component = NSDraggingImageComponent(key : NSDraggingItem.ImageComponentKey.icon)
                component.contents = image
                component.frame = NSRect(origin: NSPoint(), size: draggingFrame.size)

                return [component]
            }

            // Begin actual dragging session. Woohow!
            beginDraggingSession(with: [draggingItem], event: mouseDownEvent!, source: self)
        }
    }
}

import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

    /// The "BackElevated" asset catalog color resource.
    static let backElevated = ColorResource(name: "BackElevated", bundle: resourceBundle)

    /// The "BackIOSPrimary" asset catalog color resource.
    static let backIOSPrimary = ColorResource(name: "BackIOSPrimary", bundle: resourceBundle)

    /// The "BackPrimary" asset catalog color resource.
    static let backPrimary = ColorResource(name: "BackPrimary", bundle: resourceBundle)

    /// The "BackSecondary" asset catalog color resource.
    static let backSecondary = ColorResource(name: "BackSecondary", bundle: resourceBundle)

    /// The "Blue" asset catalog color resource.
    static let blue = ColorResource(name: "Blue", bundle: resourceBundle)

    /// The "Gray" asset catalog color resource.
    static let gray = ColorResource(name: "Gray", bundle: resourceBundle)

    /// The "GrayLight" asset catalog color resource.
    static let grayLight = ColorResource(name: "GrayLight", bundle: resourceBundle)

    /// The "Green" asset catalog color resource.
    static let green = ColorResource(name: "Green", bundle: resourceBundle)

    /// The "LabelDisable" asset catalog color resource.
    static let labelDisable = ColorResource(name: "LabelDisable", bundle: resourceBundle)

    /// The "LabelPrimary" asset catalog color resource.
    static let labelPrimary = ColorResource(name: "LabelPrimary", bundle: resourceBundle)

    /// The "LabelSecondary" asset catalog color resource.
    static let labelSecondary = ColorResource(name: "LabelSecondary", bundle: resourceBundle)

    /// The "LabelTertiary" asset catalog color resource.
    static let labelTertiary = ColorResource(name: "LabelTertiary", bundle: resourceBundle)

    /// The "NavBarBlur" asset catalog color resource.
    static let navBarBlur = ColorResource(name: "NavBarBlur", bundle: resourceBundle)

    /// The "Overlay" asset catalog color resource.
    static let overlay = ColorResource(name: "Overlay", bundle: resourceBundle)

    /// The "Red" asset catalog color resource.
    static let red = ColorResource(name: "Red", bundle: resourceBundle)

    /// The "Separator" asset catalog color resource.
    static let separator = ColorResource(name: "Separator", bundle: resourceBundle)

    /// The "White" asset catalog color resource.
    static let white = ColorResource(name: "White", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "Calendar" asset catalog image resource.
    static let calendar = ImageResource(name: "Calendar", bundle: resourceBundle)

    /// The "Calendar-2" asset catalog image resource.
    static let calendar2 = ImageResource(name: "Calendar-2", bundle: resourceBundle)

    /// The "Plus" asset catalog image resource.
    static let plus = ImageResource(name: "Plus", bundle: resourceBundle)

    /// The "cell" asset catalog image resource.
    static let cell = ImageResource(name: "cell", bundle: resourceBundle)

    /// The "completed" asset catalog image resource.
    static let completed = ImageResource(name: "completed", bundle: resourceBundle)

    /// The "highPriority" asset catalog image resource.
    static let highPriority = ImageResource(name: "highPriority", bundle: resourceBundle)

    /// The "hobbyColor" asset catalog image resource.
    static let hobby = ImageResource(name: "hobbyColor", bundle: resourceBundle)

    /// The "icon" asset catalog image resource.
    static let icon = ImageResource(name: "icon", bundle: resourceBundle)

    /// The "iconPickerHighPriority" asset catalog image resource.
    static let iconPickerHighPriority = ImageResource(name: "iconPickerHighPriority", bundle: resourceBundle)

    /// The "iconPickerLowPriority" asset catalog image resource.
    static let iconPickerLowPriority = ImageResource(name: "iconPickerLowPriority", bundle: resourceBundle)

    /// The "modeLight" asset catalog image resource.
    static let modeLight = ImageResource(name: "modeLight", bundle: resourceBundle)

    /// The "otherColor" asset catalog image resource.
    static let other = ImageResource(name: "otherColor", bundle: resourceBundle)

    /// The "plusLight" asset catalog image resource.
    static let plusLight = ImageResource(name: "plusLight", bundle: resourceBundle)

    /// The "propOff" asset catalog image resource.
    static let propOff = ImageResource(name: "propOff", bundle: resourceBundle)

    /// The "studyingColor" asset catalog image resource.
    static let studying = ImageResource(name: "studyingColor", bundle: resourceBundle)

    /// The "workColor" asset catalog image resource.
    static let work = ImageResource(name: "workColor", bundle: resourceBundle)

}

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Hashable {

    /// An asset catalog color resource name.
    fileprivate let name: String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Hashable {

    /// An asset catalog image resource name.
    fileprivate let name: String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif
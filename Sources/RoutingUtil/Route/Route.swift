import Combine
import Foundation

extension Route {
  public final class Object: ObservableObject {
    @Published public var value: Route?

    public init (_ value: Route? = nil) {
      self.value = value
    }
  }

  public  enum HandlingResult {
    case unhandled
    case handled
    case completed
  }

  public struct Options: OptionSet {
    public static let tryAll = Self(rawValue: 1 << 0)
    public static let descentHandled = Self(rawValue: 1 << 1)
    public static let ignoreUnhandled = Self(rawValue: 1 << 2)
    
    public let rawValue: Int

    public init (rawValue: Int) {
      self.rawValue = rawValue
    }
  }
}

public struct Route: Equatable {
  public  static func == (lhs: Route, rhs: Route) -> Bool { lhs.id == rhs.id }

  public let id: UUID
  public let components: [RouteComponent]
  public let options: Options

  private init (id: UUID, components: [RouteComponent], options: Options) {
    self.id = id
    self.components = components
    self.options = options
  }

  public init (_ components: [RouteComponent], options: Options = .ignoreUnhandled) {
    self.init(id: .init(), components: components, options: options)
  }

  public init (_ component: RouteComponent, options: Options = .ignoreUnhandled) {
    self.init(id: .init(), components: [component], options: options)
  }

  public func withRemovedComponents (at index: Int) -> Self {
    var components = components
    components.remove(at: index)

    return .init(id: id, components: components, options: options)
  }
}

extension Route: ExpressibleByArrayLiteral {
  public init (arrayLiteral components: RouteComponent...) {
    self.init(id: .init(), components: components, options: .ignoreUnhandled)
  }
}

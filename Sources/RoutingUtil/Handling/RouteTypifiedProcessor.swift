public struct RouteTypifiedProcessor {
  public let handlers: [any PRouteComponentHandler]
  public let defaultHandler: ((RouteComponent) -> Route.HandlingResult)?
  public let descendantHandler: ((Route) -> Void)?

  public init (
    handlers: [any PRouteComponentHandler],
    defaultHandler: ((RouteComponent) -> Route.HandlingResult)? = nil,
    descendantHandler: ((Route) -> Void)? = nil
  ) {
    self.handlers = handlers
    self.defaultHandler = defaultHandler
    self.descendantHandler = descendantHandler
  }
}

public extension RouteTypifiedProcessor {
  func process (route: Route?) {
    guard let route = route else { return }

    if route.options.contains(.tryAll) {
      handleAllComponents(of: route)
    } else {
      handleFirstComponent(of: route)
    }
  }
}

private extension RouteTypifiedProcessor {
  func handleAllComponents (of route: Route) {
    for (index, component) in route.components.enumerated() {
      switch handle(routeComponent: component) {
      case .unhandled:
        continue

      case .handled:
        if route.options.contains(.descentHandled) { descendantHandler?(route) }
        else { descendantHandler?(route.withRemovedComponents(at: index)) }
        return

      case .completed:
        return
      }
    }

    if route.options.contains(.ignoreUnhandled) { descendantHandler?(route) }
    else { return }
  }

  func handleFirstComponent (of route: Route) {
    guard let firstComponent = route.components.first else { return }

    switch handle(routeComponent: firstComponent) {
    case .unhandled:
      if route.options.contains(.ignoreUnhandled) { descendantHandler?(route) }
      else { return }

    case .handled:
      if route.options.contains(.descentHandled) { descendantHandler?(route) }
      else { descendantHandler?(route.withRemovedComponents(at: 0)) }
      return

    case .completed:
      return
    }
  }

  func handle <RC: RouteComponent> (routeComponent: RC) -> Route.HandlingResult {
    for handler in handlers {
      if let castedHandler = cast(handler, toTypeOf: routeComponent) {
        return castedHandler.handling(routeComponent)
      }
    }

    return defaultHandler?(routeComponent) ?? .unhandled
  }

  func cast <T> (_ value: Any, toTypeOf _: T) -> RouteComponentHandler<T>? {
    value as? RouteComponentHandler<T>
  }
}

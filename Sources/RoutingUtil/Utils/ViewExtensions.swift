import SwiftUI
import Combine

public extension View {
  func route (_ route: Route?) -> some View {
    environmentObject(Route.Object(route))
  }

  func route (_ component: RouteComponent, options: Route.Options = .ignoreUnhandled) -> some View {
    environmentObject(Route.Object(.init([component], options: options)))
  }

  func route (_ components: [RouteComponent], options: Route.Options = .ignoreUnhandled) -> some View {
    environmentObject(Route.Object(.init(components, options: options)))
  }
}

public extension View {
  func subscribeOn <P> (
    route publisher: P,
    descendantHandler: ((Route) -> Void)? = nil,
    defaultHandler: ((RouteComponent) -> Route.HandlingResult)? = nil,
    handlers: any PRouteComponentHandler...
  )
  -> some View where P: Publisher, P.Output == Route?, P.Failure == Never
  {
    let router = RouteTypifiedProcessor(
      handlers: handlers,
      defaultHandler: defaultHandler,
      descendantHandler: descendantHandler
    )
    return onReceive(publisher, perform: router.process(route:))
  }

  func subscribeOn <P> (
    route publisher: P,
    descendantRoute: Binding<Route?>,
    defaultHandler: ((RouteComponent) -> Route.HandlingResult)? = nil,
    handlers: any PRouteComponentHandler...
  )
  -> some View where P: Publisher, P.Output == Route?, P.Failure == Never
  {
    let router = RouteTypifiedProcessor(
      handlers: handlers,
      defaultHandler: defaultHandler,
      descendantHandler: { descendantRoute.wrappedValue = $0 }
    )
    return onReceive(publisher, perform: router.process(route:))
  }
}

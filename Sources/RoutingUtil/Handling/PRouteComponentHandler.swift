public protocol PRouteComponentHandler {
  associatedtype RC: RouteComponent

  var type: RC.Type { get }
  var handling: (RC) -> Route.HandlingResult { get }
}

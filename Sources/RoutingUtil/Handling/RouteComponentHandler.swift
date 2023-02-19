public typealias RCH<RC: RouteComponent> = RouteComponentHandler<RC>
public struct RouteComponentHandler <RC: RouteComponent>: PRouteComponentHandler {
  public let type: RC.Type
  public let handling: (RC) -> Route.HandlingResult

  public init (_ handling: @escaping (RC) -> Route.HandlingResult) {
    self.type = RC.self
    self.handling = handling
  }
}

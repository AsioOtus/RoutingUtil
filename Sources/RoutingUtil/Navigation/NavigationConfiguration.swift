public struct NavigationConfiguration <Navigation>: RouteComponent {
  public let update: (_ state: inout Navigation) -> Void

  public init (_ configuration: @escaping (_ state: inout Navigation) -> Void) {
    self.update = configuration
  }

  public init (_ navigation: Navigation) {
    self.init { $0 = navigation }
  }

  public init () {
    self.init { _ in }
  }
}

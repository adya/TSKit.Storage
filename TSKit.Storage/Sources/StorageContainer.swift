// - Since: 01/21/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.Storage/blob/master/LICENSE.md

/**
 Handy access to storage from any object.
 Simply conform to `StorageContainer` to enable storage on any component.
*/
@available(*, deprecated, message: "Use Injector instead")
protocol StorageContainer {

    /// A `storage` object associated with `self`.
    var storage: AnyStorage { get }

    /// A `storage` object associated with `self` type.
    static var storage: AnyStorage { get }

}

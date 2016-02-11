/**
 * Synchronized pattern from Java. However, returning from the action is not possible in Swift.
 *
 * - parameter lock: Lock object
 * - parameter action: Block to run while synchronized
 */
public func synchronized(lock: AnyObject, @noescape action: () -> Void) {
    objc_sync_enter(lock)
    action()
    objc_sync_exit(lock)
}
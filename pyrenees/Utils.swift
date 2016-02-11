public func synchronized(lock: AnyObject, @noescape action: () -> Void) {
    objc_sync_enter(lock)
    action()
    objc_sync_exit(lock)
}
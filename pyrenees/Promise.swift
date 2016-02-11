/**
 * **Promise**
 *
 * Simple promise with a single callback. Used by client.
 */
public class Promise<T>: IPromise {
    private let invalidationLock = NSObject()

    private var onSuccessAction: (T) -> Void = { _ in }
    private var runOnSuccessOnMain = true
    private var isValid: Bool

    private init() {
        self.isValid = true
    }

    /**
     * Attachs callback to run on main thread
     *
     * - parameter action: Callback
     *
     * - returns: Itself
     */
    public func onSuccess(action: (T) -> Void) -> Promise<T> {
        self.onSuccessAction = action
        return self
    }

    /**
     * Attachs callback to run on a background thread
     *
     * - parameter action: Callback
     *
     * - returns: Itself
     */
    public func onSuccessInBackground(action: (T) -> Void) -> Promise<T> {
        self.onSuccessAction = action
        self.runOnSuccessOnMain = false
        return self
    }

    /**
     * Invalidates promise
     */
    public func invalidate() {
        synchronized(invalidationLock) {
            self.isValid = false
        }
    }
}

/**
 * **PromiseTrigger**
 *
 * Triggers actions on parent promise. Used by server.
 */
public class PromiseTrigger<T> {
    private weak var parent: Promise<T>?

    private init(parent: Promise<T>) {
        self.parent = parent
    }

    /**
     * Triggers onSuccess action
     *
     * - parameter t: Outcome to pass
     */
    public func onSuccess(t: T) {
        let queue = (self.parent!.runOnSuccessOnMain) ? dispatch_get_main_queue() : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

        dispatch_async(queue) {
            if self.parent!.isValid {
                synchronized(self.parent!.invalidationLock) {
                    if self.parent!.isValid {
                        self.parent!.onSuccessAction(t)
                    }
                }
            }
        }
    }
}

/**
 * **PromiseBuilder**
 *
 * Builds a promise and its trigger pair. Used by server.
 */
public class PromiseBuilder<T> {
    private init() { }

    /**
     * Builds promise tuple
     *
     * - returns Promise/Trigger tuple
     */
    public static func build() -> (itself: Promise<T>, trigger: PromiseTrigger<T>) {
        let p = Promise<T>()
        return (p, PromiseTrigger<T>(parent: p))
    }
}

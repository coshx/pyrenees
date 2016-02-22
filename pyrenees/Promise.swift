/**
 * **Promise**
 *
 * Simple promise with a single callback. Used by client.
 */
public class Promise<T>: IPromise {
    private let invalidationLock = NSObject()

    private var isValid: Bool
    private var nextCallInBackground = false
    private var allInBackgroundValue = false
    private var onSuccessAction: (inBackground: Bool, action: ((T) -> Void)?)?

    private init() {
        self.isValid = true
    }

    /**
     * Runs any callback in background
     *
     * - returns: itself
     */
    public func allInBackground() -> Promise<T> {
        self.allInBackgroundValue = true
        return self
    }

    /**
     * Runs next attached callback in background
     *
     * - returns: itself
     */
    public func inBackground() -> Promise<T> {
        self.nextCallInBackground = true
        return self
    }

    /**
     * Attachs new callback
     *
     * - parameter action: Callback
     *
     * - returns: Itself
     */
    public func onSuccess(action: (T) -> Void) -> Promise<T> {
        onSuccessAction = (allInBackgroundValue || nextCallInBackground, action)
        nextCallInBackground = false
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

        guard let p1 = self.parent where p1.isValid else {
            return
        }

        guard let tuple = p1.onSuccessAction else {
            return
        }

        let queue = (tuple.inBackground) ? dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) : dispatch_get_main_queue()
        dispatch_async(queue) {
            guard let p2 = self.parent where p2.isValid else {
                return
            }
            synchronized(p2.invalidationLock) {
                if p2.isValid {
                    tuple.action?(t)
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
     * - returns: Promise/Trigger tuple
     */
    public static func build() -> (itself: Promise<T>, trigger: PromiseTrigger<T>) {
        let p = Promise<T>()
        return (p, PromiseTrigger<T>(parent: p))
    }
}

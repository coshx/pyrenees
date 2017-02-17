/**
 * **Promise**
 *
 * Simple promise with a single callback. Used by client.
 */
open class Promise<T>: IPromise {
    fileprivate let invalidationLock = NSObject()

    fileprivate var isValid: Bool
    fileprivate var nextCallInBackground = false
    fileprivate var allInBackgroundValue = false
    fileprivate var onSuccessAction: (inBackground: Bool, action: ((T) -> Void)?)?

    fileprivate init() {
        self.isValid = true
    }

    /**
     * Runs any callback in background
     *
     * - returns: itself
     */
    open func allInBackground() -> Promise<T> {
        self.allInBackgroundValue = true
        return self
    }

    /**
     * Runs next attached callback in background
     *
     * - returns: itself
     */
    open func inBackground() -> Promise<T> {
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
    open func onSuccess(_ action: ((T) -> Void)?) -> Promise<T> {
        onSuccessAction = (allInBackgroundValue || nextCallInBackground, action)
        nextCallInBackground = false
        return self
    }

    /**
     * Invalidates promise
     */
    open func invalidate() {
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
open class PromiseTrigger<T> {
    fileprivate weak var parent: Promise<T>?

    fileprivate init(parent: Promise<T>) {
        self.parent = parent
    }

    /**
     * Triggers onSuccess action
     *
     * - parameter t: Outcome to pass
     */
    open func onSuccess(_ t: T) {

        guard let p1 = self.parent, p1.isValid else {
            return
        }

        guard let tuple = p1.onSuccessAction else {
            return
        }

        let queue = (tuple.inBackground) ? DispatchQueue.global(qos: .default) : DispatchQueue.main
        queue.async {
            guard let p2 = self.parent, p2.isValid else {
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
open class PromiseBuilder<T> {
    fileprivate init() { }

    /**
     * Builds promise tuple
     *
     * - returns: Promise/Trigger tuple
     */
    open static func build() -> (itself: Promise<T>, trigger: PromiseTrigger<T>) {
        let p = Promise<T>()
        return (p, PromiseTrigger<T>(parent: p))
    }
}

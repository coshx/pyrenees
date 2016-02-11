public class Promise<T>: IPromise {
    private let invalidationLock = NSObject()

    private var onSuccessAction: (T) -> Void = { _ in }
    private var runOnSuccessOnMain = true
    private var isValid: Bool

    private init() {
        self.isValid = true
    }

    public func onSuccess(action: (T) -> Void) -> Promise<T> {
        self.onSuccessAction = action
        return self
    }

    public func onSuccessInBackground(action: (T) -> Void) -> Promise<T> {
        self.onSuccessAction = action
        self.runOnSuccessOnMain = false
        return self
    }

    public func invalidate() {
        synchronized(invalidationLock) {
            self.isValid = false
        }
    }
}

public class PromiseTrigger<T> {
    private weak var parent: Promise<T>?

    private init(parent: Promise<T>) {
        self.parent = parent
    }

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

public class PromiseBuilder<T> {
    public static func build() -> (itself: Promise<T>, trigger: PromiseTrigger<T>) {
        let p = Promise<T>()
        return (p, PromiseTrigger<T>(parent: p))
    }
}

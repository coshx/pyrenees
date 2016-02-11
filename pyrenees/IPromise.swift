/**
 * **IPromise**
 *
 * Generic interface for promises
 */
public protocol IPromise {
    /**
     * Prevents the promise from running. E.g.: controller is exiting
     */
    func invalidate()
}
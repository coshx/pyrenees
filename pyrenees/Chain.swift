/**
 * **Chain**
 *
 * Prevents spaghetti code/ pyramid of doom when running multiple asynchronous actions
 * *then* functions might need to be hard typed if types are not guessable automatically by the compiler.
 */
open class Chain<T> {
    /**
     * Trigger the chain from the start
     */
    fileprivate var runCommand: ((Void) -> Void)?
    /**
     * Runs tailing command
     */
    fileprivate var nextCommand: ((T?) -> Void)?

    fileprivate init() { }

    fileprivate func next(_ t: T?) {
        self.nextCommand?(t)
    }

    /**
     * Queues a new command
     *
     * - parameter command: Command to run. First arg is an optinal argument from previous block, second one is the trigger for the tailing block
     *
     * - returns: Tailing chain
     */
    open func then<U>(_ command: @escaping (T?, (U?) -> Void) -> Void) -> Chain<U> {
        let e = Chain<U>()

        nextCommand = { command($0, e.next) }
        e.runCommand = runCommand

        return e
    }

    /**
     * Ends chain and starts it immediately after the block
     *
     * - parameter command: Final command to run. Argument is the
     */
    open func endWith(_ command: @escaping (T?) -> Void) {
        nextCommand = command
        runCommand!()
    }

    /**
     * Starts a new chain
     *
     * - parameter command: Action to run. Argument is the trigger for running tailing block.

     * - returns: New chain
     */
    open static func startWith<U>(_ command: @escaping (_ next: @escaping (U?) -> Void) -> Void) -> Chain<U> {
        let e = Chain<U>()

        e.runCommand = { command(e.next) }

        return e
    }
}

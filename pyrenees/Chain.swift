/**
 * **Chain**
 *
 * Prevents spaghetti code/ pyramid of doom when running multiple asynchronous actions
 * *then* functions might need to be hard typed if types are not guessable automatically by the compiler.
 */
public class Chain<T> {
    /**
     * Trigger the chain from the start
     */
    private var runCommand: (Void -> Void)?
    /**
     * Runs tailing command
     */
    private var nextCommand: (T? -> Void)?

    private init() { }

    private func next(t: T?) {
        self.nextCommand?(t)
    }

    /**
     * Queues a new command
     *
     * - parameter command: Command to run. First arg is an optinal argument from previous block, second one is the trigger for the tailing block
     */
    public func then<U>(command: (T?, U? -> Void) -> Void) -> Chain<U> {
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
    public func endWith(command: T? -> Void) {
        nextCommand = command
        runCommand!()
    }

    /**
     * Starts a new chain
     *
     * - parameter command: Action to run. Argument is the trigger for running tailing block.
     */
    public static func startWith(command: (T? -> Void) -> Void) -> Chain<T> {
        let e = Chain<T>()

        e.runCommand = { command(e.next) }

        return e
    }
}
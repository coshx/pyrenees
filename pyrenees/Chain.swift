public class Chain<T> {
    private var runCommand: (Void -> Void)?
    private var nextCommand: (T? -> Void)?

    private init() { }

    private func next(t: T?) {
        self.nextCommand?(t)
    }

    public func then<U>(command: (T?, U? -> Void) -> Void) -> Chain<U> {
        let e = Chain<U>()

        nextCommand = { command($0, e.next) }
        e.runCommand = runCommand

        return e
    }

    public func endWith(command: T? -> Void) {
        nextCommand = command
        runCommand!()
    }

    public static func startWith(command: (T? -> Void) -> Void) -> Chain<T> {
        let e = Chain<T>()

        e.runCommand = { command(e.next) }

        return e
    }
}
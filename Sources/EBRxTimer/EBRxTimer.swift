import RxSwift
import Foundation

public struct EETimer {
    
    public enum State {
        case Start
        case End
    }
    
    ///开始输出start，然后经过 period 秒输出end，经过 dueTime 秒输出 start，如此循环
    public static func timerMode1(dueTime: RxSwift.RxTimeInterval, period: RxSwift.RxTimeInterval) -> Observable<EETimer.State> {
        Observable<Int>.timer(.seconds(0), period: min(dueTime, period), scheduler: MainScheduler.instance)
            .scan(into: (dueTime, EETimer.State.Start), accumulator: { (value, index) -> Void in
                if index % 2 == 0 {
                    value = (period, EETimer.State.End)
                } else {
                    value = (dueTime, EETimer.State.Start)
                }
            })
            .concatMap { (value) -> Observable<EETimer.State> in
                return Observable<Int>
                    .timer(value.0, scheduler: MainScheduler.instance)
                    .map { _ in value.1 }
            }
            .startWith(.Start)
    }
    
    ///一开始发出start，经过 period 秒后发出end然后结束
    public static func timerMode2(period: RxSwift.RxTimeInterval) -> Observable<EETimer.State> {
        Observable<Int>.timer(period, scheduler: MainScheduler.instance)
            .map({ _ in EETimer.State.End })
            .startWith(EETimer.State.Start)
    }
    
    ///经过 dueTime 后从 values 中取第一个值，然后每 period 从 array 中取下一个值，经过 timeout 后结束
    public static func timerMode3<T>(dueTime: RxSwift.RxTimeInterval, period: RxSwift.RxTimeInterval, timeout: RxSwift.RxTimeInterval, values: [T]) -> Observable<T> {
        let observable = Observable<Int>
            .timer(dueTime, period: period, scheduler: MainScheduler.instance)
            .map({ second -> T in
                let index = (second % values.count)
                return values[index]
            })
        let dead = Observable<Int>.timer(timeout, scheduler: MainScheduler.instance)
        return observable.take(until: dead)
    }
    
    ///正序计时器 1、2、3、4，在 onNext 中监听数字变化，没有结束
    public static func timer() -> Observable<Int> {
        Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .scan(0, accumulator: { (a, i) -> Int in
                return i + 1
            })
    }
    
    ///正序计时器 1、2、3、4，在 onNext 中监听数字变化，在 onCompelete 中监听结束
    public static func timer(second: Int) -> Observable<Int> {
        Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .take(second)
            .scan(0, accumulator: { (a, i) -> Int in
                return i + 1
            })
    }
    
    ///反序计时器 3、2、1、0，在 onNext 中监听数字变化，在 onCompelete 中监听结束
    public static func timerRe(second: Int) -> Observable<Int> {
        Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .take(second)
            .scan(second, accumulator: { (a, i) -> Int in
                return a - 1
            })
    }
    
}

extension DispatchTimeInterval: Comparable {
    private var totalNanoseconds: Int64 {
        switch self {
        case .nanoseconds(let ns):
            return Int64(ns)
        case .microseconds(let us):
            return Int64(us) * 1_000
        case .milliseconds(let ms):
            return Int64(ms) * 1_000_000
        case .seconds(let s):
            return Int64(s) * 1_000_000_000
        case .never:
            return Int64.max
        @unknown default:
            return Int64.max
        }
    }
    
    public static func <(lhs: DispatchTimeInterval, rhs: DispatchTimeInterval) -> Bool {
        return lhs.totalNanoseconds < rhs.totalNanoseconds
    }
    
    public static func >(lhs: DispatchTimeInterval, rhs: DispatchTimeInterval) -> Bool {
        return lhs.totalNanoseconds > rhs.totalNanoseconds
    }
}

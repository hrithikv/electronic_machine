import Foundation

public enum Result<Value> {
    case success(Value)
    case failure(Error)

    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

extension Result: CustomStringConvertible {
    public var description: String {
        switch self {
        case .success:
            return "SUCCESS"
        case .failure:
            return "FAILURE"
        }
    }
}

extension Result: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .success(let value):
            return "SUCCESS: \(value)"
        case .failure(let error):
            return "FAILURE: \(error)"
        }
    }
}

extension Result {
    public init(value: () throws -> Value) {
        do {
            self = try .success(value())
        } catch {
            self = .failure(error)
        }
    }

    public func unwrap() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
    public func map<T>(_ transform: (Value) -> T) -> Result<T> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func mapError<Error2>(_ transform: (Error) -> Error2) -> Result<Value, Error> {
	    	return flatMapError { .failure(transform($0)) }
	  }

  	public func flatMapError<Error>(_ transform: (Error) -> Result<Value, Error>) -> Result<Value, Error> {
	 	   switch self {
		      case let .success(value): return .success(value)
		      case let .failure(error): return transform(error)
		   }
	  }

	  public func bimap<U, Error>(success: (Value) -> U, failure: (Error) -> Error) -> Result<U, Error> {
		   switch self {
		      case let .success(value): return .success(success(value))
		      case let .failure(error): return .failure(failure(error))
		   }
	  }
    
    @discardableResult
    public func withValue(_ closure: (Value) -> Void) -> Result {
        if case let .success(value) = self { closure(value) }
        return self
    }
    
    @discardableResult
    public func ifSuccess(_ closure: () -> Void) -> Result {
        if isSuccess { closure() }
        return self
    }
    
    @discardableResult
    public func ifFailure(_ closure: () -> Void) -> Result {
        if isFailure { closure() }
        return self
    }
}

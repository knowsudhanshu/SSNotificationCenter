public class SSNotificationCenter {
    
    public static let shared: SSNotificationCenter = SSNotificationCenter()
    
    /*
     [ClassName:
                [NotificationName:
                                  [Function]
                ]
     ]
     */
    
    private var notificationRepository: [String: [String: [(String, Any) -> Void]]]
    
    func observerCount(for notificationName: String) -> Int {
        var count: Int = 0
        for (_, notificationData) in notificationRepository {
            for (name, closures) in notificationData {
                guard name == notificationName else { continue }
                
                for _ in closures {
                    count += 1
                }
            }
        }
        return count
    }
    
    private init() {
        // To restrict initialization
        notificationRepository = [:]
    }
    
    public func addObserver(_ _class: Any, notificationName: String, closure: @escaping ((String, Any) -> Void)) {
        
        guard let inputClass = type(of: _class) as? AnyClass else {
            return
        }
        
        
        let className = String(describing: inputClass)
        
        if let notificationData = notificationRepository[className], var _ = notificationData[notificationName] {
            notificationRepository[className]?[notificationName]?.append(closure)
        } else if let notificationData = notificationRepository[className]  {
            if var _ = notificationData[notificationName] {
                notificationRepository[className]?[notificationName]?.append(closure)
            } else {
                notificationRepository[className]?[notificationName] = [closure]
            }
        } else {
            notificationRepository[className] = [notificationName: [closure]]
        }
    }
    
    public func removeObserver(_ _class: Any, notificationName: String) {
        guard let inputClass = type(of: _class) as? AnyClass else { return }
        
        let className = String(describing: inputClass)
        
        notificationRepository.removeValue(forKey: className)
    }
    
    public func post(_ notificationName: String, object: Any) {
        for (_, notificationData) in notificationRepository {
            for (name, closures) in notificationData {
                guard name == notificationName else { continue }
                
                for closure in closures {
                    closure(notificationName, object)
                }
            }
        }
    }
}

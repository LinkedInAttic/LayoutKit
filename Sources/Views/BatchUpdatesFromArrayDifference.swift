extension BatchUpdates {
    static func calculate(old: [[Any]], new: [[Any]], elementCompareCallback: (Any, Any) -> Bool) -> BatchUpdates {
        var deleted = [IndexPath]()
        var inserted = [IndexPath]()
        var moved = [ItemMove]()

        for i in 0..<min(new.count, old.count) {
            var remainingNewValues = new[i]
                .enumerated()
                .map { (element: $0.element, offset: $0.offset, alreadyFound: false) }

            outer: for oldValue in old[i].enumerated() {
                for newValue in remainingNewValues
                    where elementCompareCallback(oldValue.element, newValue.element) && !newValue.alreadyFound {

                        if oldValue.offset != newValue.offset {
                            moved.append(ItemMove(from: IndexPath(row: oldValue.offset, section: i), to: IndexPath(row: newValue.offset, section: i)))
                        }

                        remainingNewValues[newValue.offset].alreadyFound = true

                        continue outer
                }

                deleted.append(IndexPath(row: oldValue.offset, section: i))
            }

            inserted.append(contentsOf: remainingNewValues
                .filter { !$0.alreadyFound }
                .map { IndexPath(row: $0.offset, section: i) }
            )
        }

        let batchUpdates = BatchUpdates()
        batchUpdates.deleteItems = deleted
        batchUpdates.insertItems = inserted
        batchUpdates.moveItems = moved

        let changedSections = IndexSet(min(new.count, old.count)..<max(new.count, old.count))
        if new.count > old.count {
            batchUpdates.insertSections = changedSections

            for i in min(new.count, old.count)..<max(new.count, old.count) {
                batchUpdates
                    .insertItems
                    .append(contentsOf:
                        Array(0..<new[i].count)
                            .map { IndexPath(row: $0, section: i) }
                )
            }
        } else {
            batchUpdates.deleteSections = changedSections
        }
        
        return batchUpdates
    }
}

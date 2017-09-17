extension BatchUpdates {

    /// Creates new array updated using BatchUpdates
    ///
    /// - Parameter array: array to be updated
    /// - Parameter elementCreationCallback: callback for element creation
    /// - Returns: updated array
    func updateArray<T>(_ array: [[T]], elementCreationCallback: (IndexPath) -> T) -> [[T]] {
        var newArray = updateArraySections(array, elementCreationCallback: elementCreationCallback)

        newArray = updateArrayItems(newArray, elementCreationCallback: elementCreationCallback)

        return newArray
    }

    /// Creates new array with updated sections using BatchUpdates
    func updateArraySections<T>(_ array: [[T]], elementCreationCallback: (IndexPath) -> T) -> [[T]] {
        var newArray = array

        for deletedSection in deleteSections.sorted(by: { $0 > $1 }) {
            newArray.remove(safeAt: deletedSection)
        }

        for insertSection in insertSections.sorted(by: { $0 < $1 }) {
            newArray.insert([], safeAt: insertSection)
        }

        for reloadSection in reloadSections {
            if let element = newArray[safe: reloadSection] {
                newArray[safe: reloadSection] = []

                // Reloads all elements in reloaded section
                for i in 0..<element.count {
                    newArray[safe: reloadSection]?
                        .insert(elementCreationCallback(IndexPath(row: i, section: reloadSection)), safeAt: i)
                }
            }
        }

        return newArray
    }

    /// Creates new array with updated items using BatchUpdates
    func updateArrayItems<T>(_ array: [[T]], elementCreationCallback: (IndexPath) -> T) -> [[T]] {
        var newArray = array

        for deleteItem in deleteItems.sorted(by: { lhs, rhs in
            lhs.row > rhs.row
        }) {
            newArray[safe: deleteItem.section]?.remove(safeAt: deleteItem.row)
        }

        // Create new sections if needed
        for insertItem in insertItems where (insertItem.section < 0 || insertItem.section >= newArray.count) {
            newArray.insert([], safeAt: insertItem.section)
        }

        for insertItem in insertItems.sorted(by: { lhs, rhs in
            lhs.row < rhs.row
        }) {
            newArray[safe: insertItem.section]?.insert(elementCreationCallback(insertItem), safeAt: insertItem.row)
        }

        for reloadItem in reloadItems {
            newArray[safe: reloadItem.section]?[safe: reloadItem.row] = elementCreationCallback(reloadItem)
        }
        
        return newArray
    }
}

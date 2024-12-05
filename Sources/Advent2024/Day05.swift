//
//  Day05.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/24.
//

import Foundation
import AdventCore
import Algorithms

struct Day05: AdventDay {

    var orderingRules: [OrderingRule]
    var pageLists: [PageList]

    // It would be unsafe if we were to access this
    // from multiple threads. But we pinky-promise
    // never to do that.
    nonisolated(unsafe)
    var pageManager: PageManager


    init(data: String) {
        let (ruleLines, pageLines) = data
            .split(separator: "\n\n")
            .explode()!

        pageManager = PageManager()
        orderingRules = ruleLines.lines.map(OrderingRule.init)
        for orderingRule in orderingRules {
            pageManager.insertOrderingRule(orderingRule)
        }

        pageLists = pageLines.lines.map(PageList.init)
    }

    func part1() -> Int {
        return pageLists
            .filter { pageManager.isSorted($0) }
            .map(\.middleNumber)
            .reduce(0, +)
    }

    func part2() -> Int {
        return pageLists
            .filter { pageManager.isSorted($0) == false }
            .map { pageManager.sort($0) }
            .map(\.middleNumber)
            .reduce(0, +)
    }
}

extension Day05 {
    struct OrderingRule {
        var before: Int
        var after: Int

        init(_ line: some StringProtocol) {
            let (before, after) = line.split(separator: "|")
                .map { Int($0)! }
                .explode()!
            self.before = before
            self.after = after
        }
    }

    class PageManager {
        var pageRulesByID: [Int: PageRules] = [:]

        func insertOrderingRule(_ rule: OrderingRule) {
            var beforePageRules: PageRules! = pageRulesByID[rule.before]
            if beforePageRules == nil {
                beforePageRules = PageRules(pageID: rule.before)
                pageRulesByID[rule.before] = beforePageRules
            }

            var afterPageRules: PageRules! = pageRulesByID[rule.after]
            if afterPageRules == nil {
                afterPageRules = PageRules(pageID: rule.after)
                pageRulesByID[rule.after] = afterPageRules
            }

            beforePageRules.insertOrderingRule(rule)
            afterPageRules.insertOrderingRule(rule)
        }


        func sortOrder(_ page1: Int, _ page2: Int) -> SortOrder? {
            pageRulesByID[page1]?.sortedOrder(relativeTo: page2)
        }

        func isSorted(_ pageList: PageList) -> Bool {
            for combo in pageList.pages.combinations(ofCount: 2) {
                let (before, after) = combo.explode()!
                if sortOrder(before, after) == .reverse {
                    return false
                }
            }
            return true
        }

        func sort(_ pageList: PageList) -> PageList {
            if isSorted(pageList) { return pageList }

            let sortedPages = pageList.pages.sorted { a, b in
                if let order = sortOrder(a, b) {
                    return order == .forward
                }
                fatalError("These pages are not ordered")
            }
            return PageList(sortedPages)
        }
    }

    class PageRules {
        let pageID: Int
        var idsBeforeThisPage: Set<Int> = []
        var idsAfterThisPage: Set<Int> = []

        init(pageID: Int) {
            self.pageID = pageID
        }

        func insertOrderingRule(_ rule: OrderingRule) {
            if rule.before == pageID {
                idsAfterThisPage.insert(rule.after)
            }
            else if rule.after == pageID {
                idsBeforeThisPage.insert(rule.before)
            }
        }

        func sortedOrder(relativeTo otherPage: Int) -> SortOrder? {
            if idsAfterThisPage.contains(otherPage) { return .forward }
            if idsBeforeThisPage.contains(otherPage) { return .reverse }
            return nil
        }
    }

    struct PageList {
        var pages: [Int]
        
        init(_ pages: [Int]) {
            self.pages = pages
        }
        init(_ line: some StringProtocol) {
            pages = line.split(separator: ",").map { Int($0)! }
        }

        var middleNumber: Int {
            pages[(pages.count-1) / 2]
        }
    }
}

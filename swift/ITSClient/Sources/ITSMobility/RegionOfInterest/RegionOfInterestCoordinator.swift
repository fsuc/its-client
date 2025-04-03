/*
 * Software Name : ITSClient
 * SPDX-FileCopyrightText: Copyright (c) Orange SA
 * SPDX-License-Identifier: MIT
 *
 * This software is distributed under the MIT license,
 * see the "LICENSE.txt" file for more details or https://opensource.org/license/MIT/
 *
 * Software description: Swift ITS client.
 */

import Foundation

final class RegionOfInterestCoordinator {
    struct TopicUpdateRequest {
        let subscriptions: [String]
        let unsubscriptions: [String]
    }

    private let quadkeyBuilder = QuadkeyBuilder()
    private var currentDENMRegionOfInterest: RegionOfInterest?

    func updateRoadAlarmRegionOfInterest(
        latitude: Double,
        longitude: Double,
        zoomLevel: Int
    ) -> TopicUpdateRequest? {
        updateRegionOfInterest(for: .denm,
                               latitude: latitude,
                               longitude: longitude,
                               zoomLevel: zoomLevel,
                               currentRegionOfInterest: &currentDENMRegionOfInterest)
    }


    private func updateRegionOfInterest(
        for messageType: MessageType,
        latitude: Double,
        longitude: Double,
        zoomLevel: Int,
        currentRegionOfInterest: inout RegionOfInterest?) -> TopicUpdateRequest? {
        let quadkey = quadkeyBuilder.quadkeyFrom(latitude: latitude,
                                                 longitude: longitude,
                                                 zoomLevel: zoomLevel,
                                                 separator: "/")

        guard quadkey != currentRegionOfInterest?.quadkey else {
            return nil
        }

        let neighborQuadkeys = quadkeyBuilder.neighborQuadkeys(for: quadkey)
        let regionOfInterest = RegionOfInterest(quadkey: quadkey,
                                                neighborQuadkeys: neighborQuadkeys)
        let topicUpdate = updateTopicSubscriptions(newRegionOfInterest: regionOfInterest,
                                                   currentRegionOfInterest: currentRegionOfInterest,
                                                   for: messageType)
        currentRegionOfInterest = regionOfInterest

        return topicUpdate
    }

    private func updateTopicSubscriptions(
        newRegionOfInterest: RegionOfInterest,
        currentRegionOfInterest: RegionOfInterest?,
        for messageType: MessageType
    ) -> TopicUpdateRequest {
        var subscriptions = [String]()
        var unsubscriptions = [String]()

        let newQuadkeys = newRegionOfInterest.allQuadkeys
        let currentQuadkeys = currentRegionOfInterest?.allQuadkeys ?? []

        newQuadkeys.forEach { newQuadkey in
            if !currentQuadkeys.contains(newQuadkey) {
                subscriptions.append(topic(for: messageType, in: newQuadkey))
            }
        }

        currentQuadkeys.forEach { currentQuadkey in
            if !newQuadkeys.contains(currentQuadkey) {
                unsubscriptions.append(topic(for: messageType, in: currentQuadkey))
            }
        }

        return TopicUpdateRequest(subscriptions: subscriptions, unsubscriptions: unsubscriptions)
    }

    private func topic(for messageType: MessageType, in quadkey: String) -> String {
        "/outQueue/v2x/\(messageType)/+/\(quadkey)"
    }
}

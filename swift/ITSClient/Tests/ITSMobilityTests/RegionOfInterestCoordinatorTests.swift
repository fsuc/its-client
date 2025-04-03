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
import Testing
@testable import ITSMobility

struct RegionOfInterestCoordinatorTests {
    @Test("RegionOfInterestCoordinator should return 9 subscriptions and 0 unsubscription the first time")
    func regionofinterestcoordinator_should_return_9_subscriptions_and_0_unsubscription_first_time() throws {
        // Given
        let regionOfInterestCoordinator = RegionOfInterestCoordinator()

        // When
        let requestUpdate = regionOfInterestCoordinator.updateRoadAlarmRegionOfInterest(
            latitude: 43.63516355648167,
            longitude: 1.3744570239910097,
            zoomLevel: 22)

        // Then
        let unwrapRequestUpdate = try #require(requestUpdate)
        #expect(unwrapRequestUpdate.subscriptions.count == 9)
        #expect(unwrapRequestUpdate.unsubscriptions.isEmpty)
    }

    @Test("RegionOfInterestCoordinator should return 9 subscriptions and 9 unsubscriptions when updating")
    func regionofinterestcoordinator_should_return_9_subscriptions_and_9_unsubscriptions_when_updating() throws {
        // Given
        let regionOfInterestCoordinator = RegionOfInterestCoordinator()
        _ = regionOfInterestCoordinator.updateRoadAlarmRegionOfInterest(
            latitude: 43.63516355648167,
            longitude: 1.3744570239910097,
            zoomLevel: 22)

        // When
        let requestUpdate = regionOfInterestCoordinator.updateRoadAlarmRegionOfInterest(
            latitude: 43.64516355648167,
            longitude: 1.3844570239910097,
            zoomLevel: 22)

        // Then
        let unwrapRequestUpdate = try #require(requestUpdate)
        #expect(unwrapRequestUpdate.subscriptions.count == 9)
        #expect(unwrapRequestUpdate.unsubscriptions.count == 9)
    }

    @Test("RegionOfInterestCoordinator should return nil when no update")
    func regionofinterestcoordinator_should_return_nil_when_no_update() throws {
        // Given
        let regionOfInterestCoordinator = RegionOfInterestCoordinator()
        _ = regionOfInterestCoordinator.updateRoadAlarmRegionOfInterest(
            latitude: 43.63516355648167,
            longitude: 1.3744570239910097,
            zoomLevel: 22)

        // When
        let requestUpdate = regionOfInterestCoordinator.updateRoadAlarmRegionOfInterest(
            latitude: 43.63516355648101,
            longitude: 1.3744570239910001,
            zoomLevel: 22)

        // Then
        #expect(requestUpdate == nil)
    }
}


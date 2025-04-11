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

/// A protocol that defines a observer that receives events of changed road users.
@ChangeObserverActor
public protocol RoadUserChangeObserver: AnyObject, Sendable {
    /// Provides a new road user to the observer.
    /// - Parameter roadUser: The new `RoadUser`.
    func didCreate(_ roadUser: RoadUser)

    /// Provides a updated road user to the observer.
    /// - Parameter user: The updated `RoadUser`.
    func didUpdate(_ roadUser: RoadUser)

    /// Provides a deleted road user to the observer.
    /// - Parameter user: The deleted `RoadUser`.
    func didDelete(_ roadUser: RoadUser)

    /// Provides the underlying `CAM` received to the observer.
    /// - Parameter denm: The underlying `CAM`.
    func didReceiveCAM(_ cam: CAM)
}

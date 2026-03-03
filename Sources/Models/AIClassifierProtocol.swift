//
//  AIClassifierProtocol.swift
//  AIDetector
//
//  Created by Çağatay Eğilmez on 3.03.2026.
//

import UIKit

protocol AIClassifierProtocol {

    func analyze(image: UIImage) async throws -> DetectionResult
}

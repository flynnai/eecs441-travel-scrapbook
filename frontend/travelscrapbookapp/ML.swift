//
//  ML.swift
//  travelscrapbookapp
//
//  Created by Yuer Gao on 11/11/22.
//

import Foundation
import TensorFlowLiteTaskVision

// THIS DOES NOT WORK YET (if it doesn't compile, comment it out)

class MachineLearning {
    static let shared = MachineLearning() // singleton instance
    let classifier // TODO find type
    private init() {
        // Initialization
        guard let modelPath = Bundle.main.path(forResource: "model",
                                                    ofType: "tflite") else { return }

        let options = ImageClassifierOptions(modelPath: modelPath)

        // Configure any additional options:
        // options.classificationOptions.maxResults = 3
        classifier = try ImageClassifier.classifier(options: options)
    }
    
    func classifyPhoto(photo: Photo)-> Bool {
        // Convert the input image to MLImage.
        // There are other sources for MLImage. For more details, please see:
        // https://developers.google.com/ml-kit/reference/ios/mlimage/api/reference/Classes/GMLImage
        guard let image = UIImage (named: "sparrow.jpg"), let mlImage = MLImage(image: image) else { return }

        // Run inference
        let classificationResults = try classifier.classify(mlImage: mlImage)

        // TODO find way to get classificationResults into single boolean
        var isGood = true

        return isGood
    }
}


MachineLearning.shared.classifyPhoto(photo: asdfasf)

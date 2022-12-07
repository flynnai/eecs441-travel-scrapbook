//
//  ML.swift
//  travelscrapbookapp
//
//  Created by Yuer Gao on 11/11/22.
//

import Foundation
import OSLog
import TensorFlowLiteTaskVision

final class MachineLearning {
    static let shared = MachineLearning() // singleton instance
    let classifier: ImageClassifier!
    
    private init() {
        // Initialization
        guard let modelPath = Bundle.main.path(forResource: "converted_model",
                                                    ofType: "tflite") else {
            classifier = nil
            return
            
        }

        let options = ImageClassifierOptions(modelPath: modelPath)

        // Configure any additional options:
        // options.classificationOptions.maxResults = 3
        classifier = try! ImageClassifier.classifier(options: options)
        // Thread 14: Fatal error: 'try!' expression unexpectedly raised an error: Error Domain=org.tensorflow.lite.tasks Code=208 "NOT_FOUND: Input tensor has type kTfLiteFloat32: it requires specifying NormalizationOptions metadata to preprocess input images." UserInfo={NSLocalizedDescription=NOT_FOUND: Input tensor has type kTfLiteFloat32: it requires specifying NormalizationOptions metadata to preprocess input images.}
        //print("Finished initializing ML")
    }
    
    func classifyPhoto(photo: Photo)-> Bool {
        // Convert the input image to MLImage.
        // There are other sources for MLImage. For more details, please see:
        // https://developers.google.com/ml-kit/reference/ios/mlimage/api/reference/Classes/GMLImage

        // resize image
        let size = CGSize(width: 200, height: 200)
        let resizedImage = photo.image.resized(to:size)
        
        print("Classifying image with size ", resizedImage.size.width, resizedImage.size.height)
        guard let mlImage = MLImage(image: photo.image) else {
            print("Image Classifier Failed")
            return false
        }

        // Run inference
        let classificationResults: ClassificationResult = try! classifier.classify(mlImage: mlImage)
        print("Swift is fun: ", classificationResults.classifications[0].categories[0].score)

        return classificationResults.classifications[0].categories[0].score > 0.3
    }
}


//MachineLearning.shared.classifyPhoto(photo: asdfasf)

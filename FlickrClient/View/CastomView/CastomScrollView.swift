//
//  CastomScrollView.swift
//  FlickrSearchPhotos
//
//  Created by Denis Ivanov on 30.09.2020.
//  Copyright © 2020 Denis Ivanov. All rights reserved.
//

import UIKit
import Kingfisher

class CastomScrollView: UIScrollView {
    
    var imageView: UIImageView!
    
    lazy var zoomingTap: UITapGestureRecognizer = {
        $0.numberOfTapsRequired = 2
        return $0
    }(UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap)))
    
    init(imagesUrl: [URL]?, frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        decelerationRate = UIScrollView.DecelerationRate.fast
        contentInsetAdjustmentBehavior = .never
        
        createImageView(image: getImage(from: imagesUrl))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerImage()
    }
    
    private func createImageView(image: UIImage) {
        imageView = UIImageView(image: image)
        addSubview(imageView)
        configuration(from: image.size)
    }
    
    private func getImage(from urls: [URL]?) -> UIImage {
        var images = [UIImage]()
        urls?.forEach {
            KingfisherManager.shared.retrieveImage(with: $0) { result in
                do {
                    let image = try result.get().image
                    print(image)
                    images.append(image)
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
        
        return UIImage.collage(images: images)
    }
    
    private func configuration(from imageSize: CGSize) {
        contentSize = imageSize
        
        setCurrentMaxandMinZoomScale()
        zoomScale = minimumZoomScale
        
        imageView.addGestureRecognizer(zoomingTap)
        imageView.isUserInteractionEnabled = true
    }
    
    private func setCurrentMaxandMinZoomScale() {
        let boundsSize = bounds.size
        let imageSize = imageView.bounds.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale, yScale)
        
        var maxScale: CGFloat = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        }
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        
        self.minimumZoomScale = minScale
        self.maximumZoomScale = maxScale
    }
    
    private func centerImage() {
        let boundsSize = bounds.size
        var frameToCenter = imageView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageView.frame = frameToCenter
    }
    
    // MARK: - Gesture
    @objc private func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        zoom(point: location, animated: true)
    }
    
    private func zoom(point: CGPoint, animated: Bool) {
        let currectScale = zoomScale
        let minScale = minimumZoomScale
        let maxScale = maximumZoomScale
        
        if (minScale == maxScale && minScale > 1) {
            return
        }
        
        let toScale = maxScale
        let finalScale = (currectScale == minScale) ? toScale : minScale
        let zoomRect = self.zoomRect(scale: finalScale, center: point)
        zoom(to: zoomRect, animated: animated)
    }
    
    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds
        
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }
    
}

extension CastomScrollView: UIScrollViewDelegate {
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}

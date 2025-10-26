//
//  IntroViewController.swift
//  Mascotas
//
//  Created by Jan Zelaznog on 23/10/25.
//

import UIKit
import AVFoundation
import AVKit

class IntroViewController: UIViewController {
    
    var videoPlayer: AVPlayer?
    var videoPlayerController: AVPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupVideoPlayer()
    }
    
    func setupVideoPlayer() {
                 
         // URL del video
         guard let videoURL = URL(string: "http://janzelaznog.com/DDAM/iOS/mascotas/mi-mejor-amigo-rescate-animal.mp4") else {
             print(" Error en URL del video")
             return
         }
         
         print("✅ URL del video creada correctamente")
        
        // Crear el reproductor de video
        videoPlayer = AVPlayer(url: videoURL)
        videoPlayerController = AVPlayerViewController()
        videoPlayerController?.player = videoPlayer
        
        // Configurar el frame del video para que ocupe toda la pantalla
        videoPlayerController?.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 150)
        
        // Agregar el reproductor a la vista
        if let videoView = videoPlayerController?.view {
            view.addSubview(videoView)
            addChild(videoPlayerController!)
            videoPlayerController?.didMove(toParent: self)
        }
        
        // Reproducir el video automáticamente
        videoPlayer?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // IMPORTANTE: Detener el video cuando el usuario cambie de vista
        videoPlayer?.pause()
    }
    
    // Limpiar recursos cuando la vista se destruya
    deinit {
        videoPlayer?.pause()
        videoPlayer = nil
    }
}

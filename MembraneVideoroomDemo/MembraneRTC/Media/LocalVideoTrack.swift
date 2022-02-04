import WebRTC

public class LocalVideoTrack: LocalTrack {
    private let videoSource: RTCVideoSource
    private let capturer: VideoCapturer
    public let track: RTCVideoTrack
    
    /// Contains one of the following capturers
    ///  - camera - capturing video device's camera
    ///  - screensharing - capturing video from ian n-app screensharing
    ///   - file - capturing video from a file
    enum Capturer {
        case camera, screensharing, file
    }
    
    internal init(capturer: Capturer) {
        self.videoSource = ConnectionManager.createVideoSource()
        
        switch capturer {
            case .camera:
                // camera capturing does not work on iOS
                #if targetEnvironment(simulator)
                    self.capturer = FileCapturer(self.videoSource)
                #else
                    self.capturer = CameraCapturer(self.videoSource)
                #endif
            
            case .file:
                self.capturer = FileCapturer(self.videoSource)
            
            case .screensharing:
                // screen capturing does not work on iOS
                #if targetEnvironment(simulator)
                    self.capturer = FileCapturer(self.videoSource)
                #else
                     self.capturer = ScreenCapturer(self.videoSource)
                #endif
        }
        
        self.track = ConnectionManager.createVideoTrack(source: self.videoSource)
    }
    
    public func start() {
        self.capturer.startCapture()
    }
    
    public func stop() {
        self.capturer.stopCapture()
    }
    
    public func toggle() {
        self.track.isEnabled = !self.track.isEnabled
    }
    
    public func rtcTrack() -> RTCMediaStreamTrack {
        return self.track
    }
}


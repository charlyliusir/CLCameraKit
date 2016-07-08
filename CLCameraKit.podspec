Pod::Spec.new do |s|
  s.name         = "CLCameraKit"
  s.version      = "0.0.2"
  s.summary      = "行车记录仪静态库"
  s.description  = <<-DESC
                    封装方法，方便使用
                   DESC
  s.homepage     = "https://github.com/Lclmyname/CLCameraKit"
  s.license      = 'MIT' 
  s.author       = { "LiuChaolong" => "1097920530@qq.com" }
  # s.social_media_url = "http://twitter.com/yulingtianxia"
  s.source       = { :git => "https://github.com/Lclmyname/CLCameraKit.git", :tag => s.version.to_s, :commit=>"efec9bf8794db88ee879ece18a4897e6c1b1428d"}

  s.platform     = :ios, '8.0'
  s.requires_arc = true
#s.public_header_file = 'CameraKit/CameraKit.h'
#s.source_files = 'CameraKit/CameraKit.h'
  s.frameworks = 'Foundation', 'UIKit'
#s.source_files = 'CameraKit/CameraKit.h'
  s.frameworks = 'UIKit'

s.subspec 'CLNetWorking' do |ss|
ss.source_files = 'CLAFNetworking/**/*'
ss.public_header_files = 'CLAFNetworking/**/*.h'
ss.dependency 'AFNetworking'
end

s.subspec 'CLQueueManager' do |ss|
ss.source_files = 'DownloadManager/**/*'
ss.public_header_files = 'DownloadManager/**/*.h'
ss.dependency 'CLCameraKit/CLNetWorking'
end

s.subspec 'Head' do |ss|
ss.source_files = 'CameraKit/Head/**/*'
ss.public_header_files = 'CameraKit/Head/**/*.h'
end

s.subspec 'Camera' do |ss|
ss.source_files = 'CameraKit/Camera/**/*'
ss.public_header_files = 'CameraKit/Camera/**/*.h'

ss.dependency 'AFNetworking'
ss.dependency 'CLCameraKit/Const'
ss.dependency 'CLCameraKit/CLQueueManager'
ss.dependency 'CLCameraKit/Model'
ss.dependency 'CLCameraKit/Other'

end

s.subspec 'Const' do |ss|
ss.source_files = 'CameraKit/Const/**/*'
ss.public_header_files = 'CameraKit/Const/**/*.h'
end

s.subspec 'Model' do |ss|
ss.source_files = 'CameraKit/Model/**/*'
ss.public_header_files = 'CameraKit/Model/**/*.h'
ss.dependency 'CLCameraKit/CLQueueManager'
ss.dependency 'CLCameraKit/Const'
end

s.subspec 'Novatek' do |ss|
ss.source_files = 'CameraKit/Novatek/**/*'
ss.public_header_files = 'CameraKit/Novatek/**/*.h'
ss.dependency 'CLCameraKit/Camera'
ss.dependency 'CocoaAsyncSocket'
end

s.subspec 'AIT' do |ss|
ss.source_files = 'CameraKit/AIT/**/*'
ss.public_header_files = 'CameraKit/AIT/**/*.h'
ss.dependency 'CLCameraKit/Const'
ss.dependency 'CLCameraKit/Camera'
ss.dependency 'CocoaAsyncSocket'
end

s.subspec 'Other' do |ss|
ss.source_files = 'CameraKit/Other/**/*'
ss.public_header_files = 'CameraKit/Other/**/*.h'
ss.library = 'resolv'
end


end

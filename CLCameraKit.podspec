Pod::Spec.new do |s|
  s.name         = "CLCameraKit"
  s.version      = "0.0.1"
  s.summary      = "行车记录仪静态库"
  s.description  = <<-DESC
                    封装方法，方便使用
                   DESC
  s.homepage     = "https://github.com/Lclmyname/CLCameraKit"
  s.license      = 'MIT' 
  s.author       = { "LiuChaolong" => "1097920530@qq.com" }
  # s.social_media_url = "http://twitter.com/yulingtianxia"
  s.source       = { :git => "https://github.com/Lclmyname/CLCameraKit.git", :tag => s.version.to_s, :commit=>"b186baae5e7830d9c26c66109a3765a4d6ae1eae"}

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
ss.source_files = 'Head/**/*'
ss.public_header_files = 'Head/**/*.h'
end

s.subspec 'Camera' do |ss|
ss.source_files = 'Camera/**/*'
ss.public_header_files = 'Camera/**/*.h'
ss.dependency 'AFNetworking'
ss.dependency 'CLCameraKit/Const','CLCameraKit/CLQueueManager','CLCameraKit/Model'
end

s.subspec 'Const' do |ss|
ss.source_files = 'Const/**/*'
ss.public_header_files = 'Const/**/*.h'
end

s.subspec 'Model' do |ss|
ss.source_files = 'Model/**/*'
ss.public_header_files = 'Model/**/*.h'
end

s.subspec 'Novatek' do |ss|
ss.source_files = 'Novatek/**/*'
ss.public_header_files = 'Novatek/**/*.h'
ss.dependency 'CLCameraKit/Const','CLCameraKit/CLNetWorking','CLCameraKit/Model'
end

s.subspec 'AIT' do |ss|
ss.source_files = 'AIT/**/*'
ss.public_header_files = 'AIT/**/*.h'
ss.dependency 'CLCameraKit/Const','CLCameraKit/CLNetWorking','CLCameraKit/Model'
end

s.subspec 'Other' do |ss|
ss.source_files = 'Other/**/*'
ss.public_header_files = 'Other/**/*.h'
end



end

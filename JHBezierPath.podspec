
Pod::Spec.new do |s|

  s.name         = "JHBezierPath"    #存储库名称
  s.version      = "1.0.1"      #版本号，与tag值一致
  s.summary      = "这是一个曲线图表"  #简介
  s.description  = "贝塞尔曲线的图表"  #描述
  s.homepage     = "https://github.com/976971956/JHBezierPath"      #项目主页，不是git地址
  s.license      = { :type => "MIT", :file => "LICENSE" }   #开源协议
  s.author             = { "jianghu" => "976971956@qq.com" }  #作者
  s.platform     = :ios, "8.0"                  #支持的平台和版本号
  s.source       = { :git => "https://github.com/976971956/JHBezierPath.git", :tag => "1.0.1" }         #存储库的git地址，以及tag值
  s.source_files  =  "JHBezierPath","*.{h,m}" #需要托管的源代码路径
  s.requires_arc = true #是否支持ARC

#  s.public_header_files = 'JHBezierView.h' # 公开头文件 打包只公开特定的头文件
# s.static_framework  =  true # 是否是静态库 这个地方很重要 假如不写这句打出来的包 就是动态库 不能使用 一运行会报错
# s.frameworks = "Foundation","UIKit"
#  s.xcconfig = {'OTHER_LDFLAGS' => '-ObjC'} # 链接设置 重要
# s.vendored_frameworks = ['bezierLine.a']
# s.vendored_libraries = 'Frameworks/**.a'
end

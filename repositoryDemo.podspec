
Pod::Spec.new do |s|

  s.name         = "JHBezierPath"    #存储库名称
  s.version      = "1.0.0"      #版本号，与tag值一致
  s.summary      = "这是一个曲线图表"  #简介
  s.description  = "贝塞尔曲线的图表"  #描述
  s.homepage     = "https://github.com/976971956/JHBezierPath"      #项目主页，不是git地址
  s.license      = { :type => "MIT", :file => "LICENSE" }   #开源协议
  s.author             = { "jianghu" => "976971956@qq.com" }  #作者
  s.platform     = :ios, "8.0"                  #支持的平台和版本号
  s.source       = { :git => "https://github.com/976971956/JHBezierPath.git", :tag => "1.0.0" }         #存储库的git地址，以及tag值
  s.source_files  =  "/Users/lijianghu/Desktop/我的GITDemo/JHBezierPath/JHBezierPath/*.{h,a}" #需要托管的源代码路径
  s.requires_arc = true #是否支持ARC

end

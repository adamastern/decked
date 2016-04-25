Pod::Spec.new do |s|
 
  s.name         = "Decked"
  s.version      = "0.1"
  s.summary      = "accessorize your UI"
  s.homepage     = "https://basememara.com"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Adam Stern" => "stern.adam1@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/adamastern/decked.git", :tag => s.version }
  s.source_files  = "Source/*.swift"
 
end
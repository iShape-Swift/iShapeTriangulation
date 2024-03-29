Pod::Spec.new do |spec|

  spec.name                       = 'iShapeTriangulation'
  spec.version                    = '1.0.3'
  spec.summary                    = 'Triangulation polygons'
  spec.authors                    = 'Nail Sharipov'
  spec.source                     = { :git => 'https://github.com/NailxSharipov/iShapeTriangulation.git', :tag => spec.version.to_s }
  spec.license                    = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage                   = 'https://github.com/NailxSharipov/iShapeTriangulation'

  spec.swift_versions             = ['5.0', '5.3']
  spec.requires_arc               = true

  spec.ios.deployment_target      = '11.0'
  spec.tvos.deployment_target     = '11.0'
  spec.macos.deployment_target    = '10.15'

  spec.source_files               = 'Sources/**/*.{h,m,swift}'


  spec.dependency                 'iGeometry', '>= 1.11.2'

end
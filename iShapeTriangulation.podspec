Pod::Spec.new do |spec|

  spec.name                       = 'iShapeTriangulation'
  spec.version                    = '0.11.0'
  spec.summary                    = 'Triangulation polygons'
  spec.authors                    = 'Nail Sharipov'
  spec.source                     = { :git => 'https://github.com/NailxSharipov/iShapeTriangulation.git', :tag => spec.version.to_s }
  spec.license                    = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage                   = 'https://github.com/NailxSharipov/iShapeTriangulation'


  spec.swift_versions             = ['4.2', '5.0']
  spec.requires_arc               = true

  spec.ios.deployment_target      = '9.0'
  spec.tvos.deployment_target     = '9.0'
  spec.watchos.deployment_target  = '4.0'
  spec.osx.deployment_target      = '10.15'

  spec.source_files               = 'Sources/**/*.swift'


  spec.dependency                 'iGeometry', '>= 1.9.0'

end
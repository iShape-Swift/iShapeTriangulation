Pod::Spec.new do |spec|

  spec.name                       = 'iShapeTriangulation'
  spec.version                    = '0.3.0'
  spec.summary                    = 'Triangulation polygons'
  spec.authors                    = 'Nail Sharipov'
  spec.source                     = { :git => 'https://github.com/NailxSharipov/iShapeTriangulation.git', :tag => spec.version.to_s }
  spec.license                    = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage                   = 'https://github.com/NailxSharipov/iShapeTriangulation'


  spec.swift_versions             = ['4.2', '5.0']
  spec.requires_arc               = true

  spec.ios.deployment_target      = '9.0'
  spec.tvos.deployment_target     = '9.0'
  spec.osx.deployment_target      = '10.9'

  spec.source_files               = 'iShapeTriangulation/Source/**/*.swift'


  spec.dependency                 'iGeometry', '>= 1.2.0'

end
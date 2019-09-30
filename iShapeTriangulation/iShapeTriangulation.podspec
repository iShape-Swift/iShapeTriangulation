Pod::Spec.new do |spec|

  spec.name                       = 'iShapeTriangulation'
  spec.version                    = '0.0.1'
  spec.summary                    = 'Triangulation of complex polygons with or without holes. A fast O(n*log(n)) algorithm based on "Triangulation of monotone polygons". The result also can be get as Delaunay triangulation.'
  spec.authors                    = 'Nail Sharipov'
  spec.source                     = { :git => 'git@github.com:NailxSharipov/iShapeTriangulation.git', :tag => spec.version.to_s }
  spec.license                    = 'MIT'
  spec.homepage                   = 'https://github.com/NailxSharipov/iShapeTriangulation'

  
  

  spec.swift_versions             = ['4.2', '5.0']
  spec.requires_arc               = true

  spec.ios.deployment_target      = '9.0'
  spec.tvos.deployment_target     = '9.0'
  spec.osx.deployment_target      = '10.9'
  spec.watchos.deployment_target  = '2.0'

  spec.source_files               = 'iShapeTriangulation/**/*.swift'


  spec.dependency                 'iGeometry'

end
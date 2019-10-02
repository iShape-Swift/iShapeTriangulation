platform :osx, '10.14'

target 'iShapeUI' do
	use_frameworks!

    project 'iShapeUI.xcodeproj'

	work_path = '../iGeometry'
	if File.exist?(work_path)
		puts "==> switch to work directory: " + work_path
		pod 'iGeometry', :path => work_path
	else
		puts "==> use cloud version"
		pod 'iGeometry'
	end

	pod 'iShapeTriangulation',				:path => './'


	post_install do |installer|
    	installer.pods_project.targets.each do |target|
        	if target.name == 'iShapeTriangulation'
            	target.build_configurations.each do |config|
                	config.build_settings['OTHER_SWIFT_FLAGS'] = '-DiShapeTest'
                	puts "iShapeTest flag added"
            	end
        	end
        end
    end

    target 'iShapeTests' do
        inherit! :search_paths
    end

end

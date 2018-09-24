module Jekyll
	require 'json'
	require 'pathname'
	require 'fileutils'

  class DataGenerator < Generator
    safe true
    def generate(site)
		weight = []
		insulin = []
		glucose = []
		bolus = []

    	site.posts.docs.each do |post|
            thedate = post.date.strftime('%Y-%m-%dT%H:%M:%SZ')
    		if post.data.key?('weight')
    			weight.push({"date" => thedate, "value" => post.data['weight']})
    		end

    		if post.data.key?('insulin')
    			insulin.push({"date" => thedate, "value" => post.data['insulin']})
    		end

    		if post.data.key?('bolus')
    			bolus.push({"date" => thedate, "value" => post.data['bolus']})
    		end

    		if post.data.key?('glucose')
    			glucose.push({"date" => thedate, "value" => post.data['glucose']})
    		end
    	end

    	path = File.join(site.source, 'data')
    	FileUtils.mkpath(path) unless File.exists?(path)

    	File.write(File.join(path, 'weight.json'), JSON.pretty_generate({"units": "kg", "code": "weight", "name": "Weight", "readings": weight}))
    	File.write(File.join(path, 'insulin.json'), JSON.pretty_generate({"units": "units", "code": "insulin", "name": "NovoRapid", "readings": insulin}))
    	File.write(File.join(path, 'bolus.json'), JSON.pretty_generate({"units": "units", "code": "bolus", "name": "Levemir", "readings": bolus}))
    	File.write(File.join(path, 'glucose.json'), JSON.pretty_generate({"units": "mmol/L", "code": "glucose", "name": "Glucose", "readings": glucose}))
    end
  end
end

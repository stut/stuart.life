module Jekyll
	require 'json'
	require 'pathname'
	require 'fileutils'

  class DataGenerator < Generator
    safe true
    def generate(site)
    	bptop = []
    	bpbot = []
		weight = []
		insulin = []
		glucose = []
		bolus = []
		hba1c = []

    	site.posts.each do |post|
            thedate = post.date.strftime('%Y-%m-%dT%H:%M:%SZ')
    		if post.data.key?('bptop') and post.data.key?('bpbot')
    			bptop.push({"date" => thedate, "value" => post.data['bptop']})
    			bpbot.push({"date" => thedate, "value" => post.data['bpbot']})
    		end

    		if post.data.key?('weight')
    			weight.push({"date" => thedate, "value" => post.data['weight']})
    		end

    		if post.data.key?('insulin')
    			insulin.push({"date" => thedate, "value" => post.data['insulin']})
    		end

    		if post.data.key?('glucose')
    			glucose.push({"date" => thedate, "value" => post.data['glucose']})
    		end

    		if post.data.key?('bolus')
    			bolus.push({"date" => thedate, "value" => post.data['bolus']})
    		end

    		if post.data.key?('hba1c')
    			hba1c.push({"date" => thedate, "value" => post.data['hba1c']})
    		end
    	end

    	path = File.join(site.source, 'data')
    	FileUtils.mkpath(path) unless File.exists?(path)

    	File.write(File.join(path, 'bp.json'), JSON.pretty_generate([bptop, bpbot]))
    	File.write(File.join(path, 'weight.json'), JSON.pretty_generate(weight))
    	File.write(File.join(path, 'insulin.json'), JSON.pretty_generate([insulin,bolus]))
    	File.write(File.join(path, 'glucose.json'), JSON.pretty_generate(glucose))
    	File.write(File.join(path, 'hba1c.json'), JSON.pretty_generate(hba1c))
    end
  end
end

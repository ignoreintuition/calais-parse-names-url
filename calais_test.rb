require 'open_calais'
require 'open-uri'

# you can configure for all calls
OpenCalais.configure do |c|
	c.api_key = "hz2e03uskJTCNvZaA7kTr8i2JUTTYzZW"
end

# or you can configure for a single call
open_calais = OpenCalais::Client.new(:api_key=>'hz2e03uskJTCNvZaA7kTr8i2JUTTYzZW')

pages = [
	'https://www.thehartford.com/about-us/',
	'https://www.thehartford.com/about-us/doug-elliot',
	'https://www.thehartford.com/about-us/leadership',
	'https://www.thehartford.com/about-us/chris-swift',
	'https://www.thehartford.com/about-us/beth-bombara',
	'https://www.thehartford.com/about-us/jonathan-bennett'
]

output = File.open( "outputfile.txt","w" )

if pages.nil?
	puts "No Input"
elsif pages.respond_to?("each")
	pages.each do |page|
		file = open(page)
		contents = file.read
		# it returns a OpenCalais::Response instance
		response = open_calais.enrich(contents)
		# which has the 'raw' response
		response.raw
		# and has been parsed a bit to get :language, :topics, :tags, :entities, :relations, :locations
		# as lists of hashes
		output <<  "----" + page + "----"
		response.entities.each{|t| 
			if t[:type] == "Person"
				output <<  t[:name]
			end
		}
	end
else
	file = open(pages)
	contents = file.read
	# it returns a OpenCalais::Response instance
	response = open_calais.enrich(contents)
	# which has the 'raw' response
	response.raw
	# and has been parsed a bit to get :language, :topics, :tags, :entities, :relations, :locations
	# as lists of hashes
	output <<  "----" + pages + "----"
	response.entities.each{|t| 
		if t[:type] == "Person"
			output <<  t[:name]
		end
	}
end

output.close

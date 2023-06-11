require 'sinatra'
require 'byebug'

# HOWTO
#
# run with `ruby file_server.rb -o 0.0.0.0`
#

# Set the public folder as the static directory
set :public_folder, File.dirname(__FILE__) + '/public'
set :port, 8000

# Set the maximum allowed file size (in bytes)
# Adjust the value as per your requirements
configure do
  set :max_file_size, 45_000_000 # 15 MB
end

post '/upload' do
  index = 0
  while (file = params["file#{index}"])
    filename = file[:name] # TODO: Info is in the header, need to parse it
    tempfile = file[:tempfile]
    
    # Save the file to the 'uploads' directory
    File.open("uploads/#{filename}.jpeg", 'wb') do |f|
      f.write(tempfile.read)
    end
    
    index += 1
  end

  'File uploaded successfully'
end

get '/test' do
  'Hello World'
end

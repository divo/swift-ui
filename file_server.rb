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
  set :max_file_size, 15_000_000 # 15 MB
end

post '/upload' do
  # Check if a file was sent
  unless params[:file]
    return 'No file selected'
  end

  # Check the file size
  if params[:file][:tempfile].size > settings.max_file_size
    return 'File size exceeds the limit'
  end

  # Save the file to the 'uploads' directory
  File.open(params[:file][:filename], 'wb') do |file|
    file.write(params[:file][:tempfile].read)
  end

  'File uploaded successfully'
end

get '/test' do
  'Hello World'
end

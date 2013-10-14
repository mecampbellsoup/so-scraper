# this is where we'll require our lib files

Dir.foreach("lib") do |file|
  next if file.start_with?('.')
  require "#{file}" if file.end_with?(".rb")
end

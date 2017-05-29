ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
RAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(RAILS_ROOT)
require 'rubygems'
require 'active_record'


ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml'))[ENV['RAILS_ENV']])

include "#{RAILS_ROOT}/app/models/contact.rb"

require 'socket'               # Get sockets from stdlib
require 'uri'

port = 2000

def parse_data data
  unescaped_data = URI.unescape(data)
  arr = unescaped_data.split("&")
  email = arr.shift.split("=").last # get email
  pages = arr.first.split("=").last[1..-1] # get pages and remove first pipe
  puts "email: #{email}"
  puts "arr: #{pages}"
  array_pages = []
  page_name = String.new
  pages.split("|").each_with_index { |pos, i|
    if (i%2 == 0)
      page_name = pos
    else
      array_pages << [page_name, pos]
    end
  }

  array_pages.sort!{ |x, y| y.last <=> x.last }
  array_pages.uniq!{ |x| x.first }

  puts "Array: #{array_pages}"

  contact = Contact.new
  #puts contact.email
  contact.insert_or_update(email, array_pages)

end

 server = TCPServer.open(port)  # Socket to listen on defined port
 loop {                         # Servers run forever
   client = server.accept       # Wait for a client to connect
   method, path = client.gets.split                    # In this case, method = "POST" and path = "/"
   headers = {}
   while line = client.gets.split(' ', 2)              # Collect HTTP headers
     break if line[0] == ""                            # Blank line means no more headers
     headers[line[0].chop] = line[1].strip             # Hash headers by type
   end
   data = client.read(headers["Content-Length"].to_i)  # Read the POST data as specified in the header

   #puts URI.unescape(data)                             # Do what you want with the POST data
   parse_data data
   #print "Received Socket\n"

   #client.puts(Time.now.ctime)  # Send the time to the client
   #client.puts "Closing the connection. Bye!"
   client.close                 # Disconnect from the client
 }

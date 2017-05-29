namespace :tracker do
  desc "TODO"
  task tcp_server_task: :environment do
  	require 'socket'
	require 'uri'

	port = 2000 # default port

	def parse_data data
	  unescaped_data = URI.unescape(data)
	  arr = unescaped_data.split("&")
	  email = arr.shift.split("=").last # get email
	  pages = arr.first.split("=").last[1..-1] # get pages and remove first pipe

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

	  puts "Email: #{email}"
	  puts "Pages and timestampts: #{array_pages}"

	  Contact.new::insert_or_update(email, array_pages)

	end

	 server = TCPServer.open(port)                         # Socket to listen on defined port
	 loop {                                                # Servers run forever
	   client = server.accept                              # Wait for a client to connect
	   method, path = client.gets.split                    # In this case, method = "POST" and path = "/"
	   headers = {}
	   while line = client.gets.split(' ', 2)              # Collect HTTP headers
	     break if line[0] == ""                            # Blank line means no more headers
	     headers[line[0].chop] = line[1].strip             # Hash headers by type
	   end
	   data = client.read(headers["Content-Length"].to_i)  # Read the POST data as specified in the header

	   puts "Request received"
	   parse_data data

	   client.close                                        # Disconnect from the client
	 }

  end

end

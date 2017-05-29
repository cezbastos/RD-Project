class Contact < ActiveRecord::Base

	validates_uniqueness_of :email, :scope => :page

	def insert_or_update(email, array_pages)
		array_pages.each { | page | 
			sec = (page.last.to_f/1000.0).to_s
			time = DateTime.strptime(sec, '%s')
			contact = Contact.where(email: email, page: page.first).first
			if contact.nil?
				contact = Contact.new(email: email, page: page.first, access_datetime: time)
				contact.save
			else
				contact.update_attribute(:access_datetime, time)
			end
		}
	end
end

#bonuses: iteration Clean phone numbers
#less than 10 digits--> bad #, 10 digits--> good, 11 digits and first digit 1, trim,
#11 digits and first digit not 1, bad #. more than 11 digits, bad #

#iteration: Time Targeting to find peak registration hours
# DateTime#strptime is a method to parse date-time strings into ruby objects
# DateTime#strftime is a good reference on chars necessary to match the format
# Date#hour finds hour of day

#iteration: day of week most people registered
#use Date#wday to find out day of the week.

require "csv"
require "sunlight/congress"
require "erb"

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id, form_letter)
  Dir.mkdir("output") unless Dir.exists? "output"

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts "Event Manager Initialized!"

contents = CSV.open "../event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "../form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letters(id, form_letter)
end

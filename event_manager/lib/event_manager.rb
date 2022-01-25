require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'date'
require 'time'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def clean_phone_number(phone_number)
  phone_number = phone_number.to_s.tr('^0-9','')
  return '' if phone_number.length < 10

  phone_number = phone_number.slice(1, 10) if phone_number.length == 11 && phone_number[0] == '1'
  phone_number
end

def convert_date_time(date_time)
  time = Time.strptime(date_time, '%m/%d/%y %H:%M')
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id,form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

hour_count = Hash.new(0)
day_of_week_count = Hash.new(0)

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  # Assignment
  phone_number = clean_phone_number(row[:homephone])
  # puts phone_number
  date_time = convert_date_time(row[:regdate])
  hour_count[date_time.hour] += 1
  day_of_week_count[date_time.strftime('%A')] += 1
  # puts date_time

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id,form_letter)
end

best_hour = (hour_count.max_by { |_, v| v })
best_wday = (day_of_week_count.max_by { |_, v| v })
puts "Most people signed up at the hour of: #{best_hour}"
puts "Most people signed up on a: #{best_wday}"

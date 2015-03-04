require 'Date'

data_file = File.new("workout stuff.csv", "r")
raw_data_array = Array.new
workout_data = Hash.new
month_data = Hash.new
months_list = {1=>"January", 2=>"February", 3=>"March", 4=>"April", 5=>"May", 6=>"June", 7=>"July", 8=>"August", 9=>"September", 10=>"October", 11=>"November", 12=>"December"}

while (line = data_file.gets)
	raw_data_array.push(line.split(","))
end

raw_data_array.each do |record|
	data_date = Date.parse(record[1].to_s)
	readable_month = months_list[data_date.month]
	workout = record[0].to_s
	workout.gsub!("\"","")
	if (workout_data["#{readable_month} #{data_date.year}"])
		if (workout_data["#{readable_month} #{data_date.year}"][workout] = record[3].to_i + workout_data["#{readable_month} #{data_date.year}"][workout].to_i)
		else
			workout_data["#{readable_month} #{data_date.year}"]={[workout]=>0}
			workout_data["#{readable_month} #{data_date.year}"][workout] = record[3].to_i + workout_data["#{readable_month} #{data_date.year}"][workout].to_i
		end
	else
		workout_data["#{readable_month} #{data_date.year}"]={[workout]=>0}
		workout_data["#{readable_month} #{data_date.year}"][workout] = record[3].to_i + workout_data["#{readable_month} #{data_date.year}"][workout].to_i
	end
end

workout_data.keys.sort!

workout_data.each do |month, data|
	puts "#{month}"
	data.each do |workout,total|
		puts "\t#{workout}: #{total}"
	end
end

=begin
raw_data_array.each do |r|
	puts "--------------------"
	puts r
	puts "--------------------"
end
=end
data_file.close
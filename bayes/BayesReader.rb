class BayesReader
	def initialize(bayes)
		@net = bayes
	end
	
	def parse_file(fname)
		file = File.new(fname, "r")
		contents = file.readlines
		new_block = true
		curr_var = nil
		contents.each do |current|
			#puts current
			#if (current.to_a[0].to_s == "P")
			if (current.start_with?("P(") && new_block)
				#puts current
				var = Variable.new(current[current.index("(")+1].to_s)
				#puts current[current.index("(")+1].to_s
				#puts var
				prob = current[current.index("=")+1, current.length].strip.to_f
				#puts prob
				@net.update_table(var, prob)
				#@net.display()
				#new_block = true
			elsif (!(current =~ /[a-zA-Z0-9]/))# && !new_block)
				if (current.chomp.strip == "")
					#puts "current: #{current}; chomped:  #{current.chomp}; stripped:  #{current.chomp.strip}"
					new_block = true
				else
					#puts "lololololol"
					#puts current
					curr_var ? curr_var.set_splitter(current) : curr_var
				end
			elsif (new_block)
				#puts "???"
				line = current.split("|")
				curr_var = Variable.new(line[1].split(" ").join(""), line[0].split(" "))
				new_block = false
			else
				#puts "current: #{current}; stuff: #{current.start_with?("P(")}; new block:  #{new_block}"
				line = current.split("|")
				#puts "curr_var: #{curr_var}"
				@net.update_table(curr_var, line[1].to_s.strip.to_f, line[0].split(" "))
			end
		end
		return @net
	end
end
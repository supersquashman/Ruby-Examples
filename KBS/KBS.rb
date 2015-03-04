require './Clause.rb'
require './Literal.rb'
require './Handler.rb'
class KBS
	
	def initialize()
		source_file = ARGV[0]
		handler = Handler.new
		final_state = false
		if (source_file && source_file.include?(".in"))
			var_file = File.new(source_file,"r")
			contents = var_file.readlines
			contents.each do |current|
				handler.addClause(current)
			end
			selection1 = handler.select
			while (!selection2 = handler.select_match(selection1))
					selection1 = handler.select
				end
			i = 0
			while(handler.resolve(selection1,selection2))
				selection1 = handler.select
				while (!selection2 = handler.select_match(selection1))
					selection1 = handler.select
				end
				if (i >= handler.end_size)
					puts "Valid Solution"
					final_state = true
					break
				end
				i+=1
			end
			handler.display(selection1,selection2, final_state, source_file)
		else
			puts "A '.in' file must be included in the arguments to run this program."
		end
		
	end
end

test = KBS.new()
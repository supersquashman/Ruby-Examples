class Handler
	attr_accessor :end_size
	def initialize
		@clauses = Array.new
		@tracker = Hash.new
		@selector = Array.new
		@select_index = Hash.new
		@end_size = 0
	end
	
	def dup_check(cl)
		dup_counter = 0
		
		nray = Array.new
		cl.literals.each do |l|
			nray.push(l.value)
		end
		@clauses.each do |c|
			c.literals.each do |cl|
				nray.include?(cl.value) ? dup_counter+=1 : nil
			end
			if dup_counter >= c.literals.size
				return false
			else
				dup_counter = 0
			end
		end
		return true
	end
	
	def addClause(tc, parentSet = [])
		claus = Clause.new(tc)
		if (dup_check(claus))
			@clauses.push(claus)
			@tracker[@clauses[@clauses.size-1]] = parentSet
			claus = Marshal.load(Marshal.dump(claus))
			@selector.push(claus)
			@select_index[claus] = @clauses.size-1
			@end_size += 1
		end
	end
	
	def refreshSelector
		@clauses.each do |cl|
			claus = Marshal.load(Marshal.dump(cl))
			@selector.push(claus)
			@select_index[claus] = @clauses.index(cl)
		end
	end
	
	def resolve(i1,i2)
		first = Marshal.load(Marshal.dump(@clauses[i1]))
		second = Marshal.load(Marshal.dump(@clauses[i2]))
		
		first.literals.each do |l|
			inv = l.inverse
			nclause = Array.new
			if second.contains?(inv)
				while (first.contains?(l.value) || first.contains?(inv))
					first.remove(first.find(l.value))
					first.remove(first.find(inv))
				end
				while (second.contains?(inv) || second.contains?(l.value))
					second.remove(second.find(inv))
					second.remove(second.find(l.value))
				end
				first.literals.each do |c|
					while(second.contains?(c.value))
						second.remove(second.find(c.value))
					end
				end
				second.literals.each do |c|
					while(first.contains?(c.value))
						first.remove(first.find(c.value))
					end
				end
				if ((first.size > 0) || (second.size > 0))
					addClause("#{first.to_s} #{second.to_s}", [i1+1,i2+1])
				else
				return false
				end
			end
		end
	end
	
	def select
		@selector.sort
		while(!@selected = @selector.pop)
			refreshSelector
		end
		return @select_index[@selected]
	end
	
	def select_match(first)
		selected = -1 
		while (selected == -1 || selected == nil)	
			Marshal.load(Marshal.dump(@clauses[first])).literals.each do |l|
					tempSelected = @selector.select{|z| z.contains?(l.inverse)}.sort.reverse!.pop
					if (tempSelected != nil)
						selected = tempSelected
					end
					if (selected == nil || @selector.size < 1)
						return false
						refreshSelector
						selected = @selector.select{|z| z.contains?(l.inverse)}.sort.reverse!.pop
						@selector.delete(selected)
					end
					selected == -1 ? (return false) : nil
			end
		end
		return @select_index[selected]
	end
	
	def display(i1=nil,i2=nil,state=false,name=nil)
		@clauses.each do |c|
			parents = "   {#{@tracker[c].join(",")}}"
			
			puts "#{@clauses.index(c)+1}.) #{c.to_s + parents}"
		end
		if (i1 && i2)
			puts "#{@clauses.length+1}.)  #{state} {#{i1+1},#{i2+1}}" 
		end
		if (name!=nil)
			if (i1 && i2)
				out_file = File.new(name.split(".")[0]+".out","w")
				@clauses.each do |c|
					parents = "   {#{@tracker[c].join(",")}}"
					
					out_file.puts "#{@clauses.index(c)+1}.) #{c.to_s + parents}"
				end
				out_file.puts "#{@clauses.length+1}.)  #{state} {#{i1+1},#{i2+1}}" 
				if (state)
					out_file.puts "Valid Solution"
				end
			end
		end
	end
end
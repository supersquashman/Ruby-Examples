class Clause
	attr_accessor :literals, :selected
	
	def initialize(c)
		@selected = false
		@literals = Array.new
		c.split(" ").each do |l|
			@literals.push(Literal.new(l))
		end
	end
	

	def to_s
		result = ""
		@literals.each do |l|
			result += " #{l.value}"
		end
		
		return result
	end
	
	def find(str)
		lit = nil
		@literals.each do |l|
			if (l.value == str)
				lit = l
			end
		end
		return lit
	end
	
	def remove(literal)
		#puts literal
		@literals -= [literal]
	end
	
	def size
		return @literals.size
	end
	
	def contains?(val)
		@literals.each do |l|
			if (l.value == val)
				return true
			end
		end
		return false
	end
	
	def <=>(other)
		size <=> other.size
	end
end
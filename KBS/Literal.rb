class Literal
	def initialize(v)
		@value = v
	end
	
	def value()
		return @value
	end
	
	def inverse
		inv = value.include?("~") ? value.delete("~") : "~#{value}"
		return inv
	end
end
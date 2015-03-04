class Variable
	attr_accessor :parents, :splitter
	
	def initialize(i="z", p=[], v=-1)
		@id = i
		@parents = p
		@value
		if (v == true || v == 1)
			@value = 1
		elsif (v == false || v == 0)
			@value = 0
		#else
		#	@value = -1
		end
	end
	
	def set_splitter(str)
		@splitter = str
	end
	
	def id
		return @id.to_s
	end
	
	def set_value(tf)
		if (v == true || v == 1)
			@value = 1
		elsif (v == false || v == 0)
			@value = 0
		else
			@value = -1
		end
	end
	
	def to_s
		return @id.to_s
	end
end
class Roll
	def derp
		stats = []
		(1..6).each do
			scores = []
			(1..4).each do
				scores.push(herp)
			end
			puts scores.join(',')
			stats.push(scores.sort.reverse[0..2].inject(:+))
		end
		puts stats.sort.reverse
	end
	
	def herp
		while (nyah = rand(6)+1) < 2
		
		end
		return nyah
	end
end

dice = Roll.new
dice.derp
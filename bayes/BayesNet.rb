class BayesNet
	def initialize
		@probability_table = Hash.new
	end
	
	def update_table(var,prob,const=[])#(var, const, prob)
		#var is the variable for which the probability is being found, prob is the probability for that variable being true given the conditions, 
		#and const is an array containing true/false values defining the current conditions
		@probability_table.has_key?(var) ? @probability_table[var].merge!({const => prob}) : @probability_table.store(var,{const=>prob})
		#@probability_table[var] = {const => prob}
	end
	
	def prob(var, const=[])
		return @probability_table[var][const]
	end
	
	def elim(query)
		
	end
	
	def enum(query)
		
	end
	
	def interpret(query)
		query_data = Array.new
		query_data.push(query) #store the query
		query_data.push(query[query.index("(")+1]) #store the variable we want the probability for
		#temp_hash = query[query.index("|")+1, query.index(")")-query.index("|")-1].split(",").each{|hs| hs.split("="[0] => hs.split("=")[1]}
		temp_hash = Hash.new
		query[query.index("|")+1, (query.index(")").to_i-query.index("|").to_i-1)].split(",").each{|hs| temp_hash[hs.split("=")[0].to_s.strip] = hs.split("=")[1].to_s.strip}
		query_data.push(temp_hash)
		return query_data
	end
	
	def find(id)
		@probability_table.keys.each do |var|
			if (var.id == id)
				return var
			end
		end
		return nil
	end
	
	def calc_prob(var, tf_val = true, given={""=>'t'})
		if (var.parents == [])
			p = prob(var)
		else
			p = 0
			set = Array.new
			var.parents.each do |parent|
				if (!given.keys.include?(parent))
					set += ['t','f']
				else
					set += [given[parent]]
				end
			end
			list = (set).combination(var.parents.length).to_a.uniq.sort.reverse
=begin
			i = 0
			var.parents.each do |parent|
				t = calc_prob(find(parent))
				puts "#{parent}: prob: #{prob(find(parent))}; calc_prob: #{calc_prob(find(parent))}; list_val: #{list[i]}, list_prob: #{prob(var,list[i])}"
				puts "#{parent}: prob: #{prob(find(parent))}; calc_prob: #{calc_prob(find(parent))}; list_val: #{list[i+var.parents.size]}, list_prob: #{prob(var,list[i+var.parents.size])}"
				f = calc_prob(find(parent),false)
				tf_val ? (p *= (t*prob(var,list[i]) + f*prob(var,list[i+var.parents.size]))) : (p *= 1-(t*prob(var,list[i]) + f*prob(var,list[i])))
				#tf_val ? (p += (t*prob(var,list[i+var.parents.size]) + f*prob(var,list[i+var.parents.size]))) : (p += 1-(t*prob(var,list[i+var.parents.size]) + f*prob(var,list[i+var.parents.size])))
				i += 1
			end
=end
			lookup = Array.new
			var.parents.each do |parent|
				if (!given.keys.include?(parent))
					lookup.push({'t'=>calc_prob(find(parent), true, given), 'f'=>calc_prob(find(parent),false, given)})
				else
					#puts ['t','f']-[given[parent]]
					lookup.push({given[parent]=>1, (['t','f'].reject{|v| v==given[parent]}[0])=>0})
					#puts lookup
				end
			end
			#puts "set: #{set}"
			#puts "list: #{list}"
			#puts "lookup: #{lookup}"
			list.each do |current|
				cur_val = 1
				#puts "current: #{current}"
				(0..current.length-1).each do |i|
					#puts "#{lookup[i][current[i]]}; current_length:  #{current.length}"
					cur_val *= lookup[i][current[i]]
				end
				#prob(var,current.to_s).to_i == 0 ? (puts "#{var} #{current} #{@probability_table[var][current]}" ) : nil
				#puts "var: #{var};  prob(var,current): #{prob(var,current)}; cur_val: #{cur_val}; result: #{(cur_val) * (prob(var,current))}; p: #{p}; add: #{p+(cur_val) * (prob(var,current))}"
				p+=(cur_val) * (prob(var,current))
			end
		end
		
		tf_val ? p = p : p = 1-p
		
		return p.round(10)
	end
	
	def display
		puts @probability_table
		@probability_table.keys.each do |var|
			puts "\r\n"
			new_block = true
			@probability_table[var].keys.each do |const|
				#puts "Const:  #{const}"
				if (const == [])
					puts "P(#{var.to_s}) = #{@probability_table[var][const]}"
					new_block = true
				else
					#puts "Const:  #{const}"
					if (new_block)
						puts "#{var.parents.join(" ")} | #{var}"
						#puts "#{const.join(" ")} | #{var}"
						puts "#{var.splitter}"
						puts "#{const.join(" ")} | #{@probability_table[var][const]}"
						new_block = false
					else
						puts "#{const.join(" ")} | #{@probability_table[var][const]}"
					end
					#puts "var: #{var}\nconst:  #{const}\nProb:  #{@probability_table[var][const]}"
				end
			end
			new_block = true
		end
	end
end
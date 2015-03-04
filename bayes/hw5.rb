require './BayesNet.rb'
require './Variable.rb'
require './BayesReader.rb'

bayes = BayesNet.new()
reader = BayesReader.new(bayes)
ARGV[0] ? bayes = reader.parse_file(ARGV[0]) : nil
if (ARGV[1] && ARGV[1].downcase == "elim")
	puts "Functionality not added"
elsif (ARGV[1] && ARGV[1].downcase == "enum")
	process = bayes.interpret(ARGV[2])
	puts "#{process[0].gsub(process[1], process[1] + "=t")}:  #{bayes.calc_prob(bayes.find(process[1]),true,process[2])}"
	puts "#{process[0].gsub(process[1], process[1] + "=f")}:  #{bayes.calc_prob(bayes.find(process[1]),false,process[2])}"
else
	puts "Invalid argument"
end

=begin
bayes = BayesNet.new()
reader = BayesReader.new(bayes)
bayes = reader.parse_file("ex2.bn")
#bayes.display()

#b = bayes.find("D")
#puts b
#puts bayes.calc_prob(b)
#puts bayes.calc_prob(b,false)
r = "P(D | A = t)"
test = bayes.interpret(r)
#puts test
puts bayes.calc_prob(bayes.find(test[1]),false,test[2])
puts " "
r = "P(C | A = t, E = f)"
test = bayes.interpret(r)
#puts test
puts bayes.calc_prob(bayes.find(test[1]),false,test[2])
#var1 = Variable.new('a')
#var1.setValue(false)
#var2 = Variable.new('b')
#var2.setValue(true)

bayes = reader.parse_file("alarm.bn")
r = "P(B | J = t,M = t)"
test = bayes.interpret(r)
#puts test
puts "P(B = t | J = t,M = t): #{bayes.calc_prob(bayes.find(test[1]),true,test[2])}"
puts "P(B = f | J = t,M = t): #{bayes.calc_prob(bayes.find(test[1]),false,test[2])}"
#puts var
#bayes.update_table(var,0.01)
#puts bayes.prob(var)
=end
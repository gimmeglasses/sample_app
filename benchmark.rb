require 'benchmark'
STRING_HASH = { 'baseball' => 'swallows' }
SYMBOL_HASH = { :baseball => 'swallows' }
NUMBER_HASH = { 2345 => 'swallows' }

# ローカル変数に代入することで、ベンチマークテストをより公平に行える。
str, sym, num = 'baseball', :baseball, 2345

n = 100_000_000
Benchmark.bmbm do |x|
  x.report("String Hash") { n.times { STRING_HASH[str] } }
  x.report("Symbol Hash") { n.times { SYMBOL_HASH[sym] } }
  x.report("Number Hash") { n.times { NUMBER_HASH[num] } }
end
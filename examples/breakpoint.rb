require_relative '../lib/blackstack_commons'

BlackStack::Debugging.set({
    # set this to false to do a monkey-patch into the `binding.pry` method,
    # in order to disable the breakpoint functionality. 
    # 
    # activate this in your development environment only.
    # never activate it in production.
    :allow_breakpoints => true, # it is false by default
    # activate this to do a `print "Breakpoint are not allowed"` when calling `binding.pry` but `allow_breakpoints` is `false`
    :verbose => true, # it is false by default
})

(1..100).each do |i|
  binding.pry if i == 50
  puts i
end
################################################################################
# Code snippets of the book:
# A. Lobianco (2019) Julia Quick Syntax Reference - A Pocket Guide for Data
# Science Programming, Apress
# https://doi.org/10.1007/978-1-4842-5190-4
# Licence: Open Domain
################################################################################

# Chapeter 3 : Control flow and functions


# Code snippet #3.1: Variable scope

a = 5
while a > 2
    global a
    println("a: $a")
    b = a
    while b > 2
        println("b: $b")
        b -= 1
    end
    a -= 1
end


# Code snippet #3.2: Nested and recursive functions

# A nested function:
function f1(x)
    function f2(x,y)
        x+y
    end
    f2(x,2)
end
# A recursive function:
function fib(n)
    if n == 0  return 0
    elseif n == 1 return 1
    else
     return fib(n-1) + fib(n-2)
    end
end


# Code snippet #3.3: Function arguments

myvalues = [1,2,3]
function additionalAverage(init, args...) #The parameter that uses the ellipsis must be the last one
  s = 0
  for arg in args
    s += arg
  end
  return init + s/length(args)
end
a = additionalAverage(10,1,2,3)        # 12.0
a = additionalAverage(10, myvalues ...)  # 12.0


# Code snippet #3.4: Call by reference, call by value

function f(x,y)
    x = 10
    y[1] = 10
end
x = 1
y = [1,1]
f(x,y) # x will not change, but y will now be [10,1]

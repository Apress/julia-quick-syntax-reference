################################################################################
# Code snippets of the book:
# A. Lobianco (2019) Julia Quick Syntax Reference - A Pocket Guide for Data
# Science Programming, Apress
# https://doi.org/10.1007/978-1-4842-5190-4
# Licence: Open Domain
################################################################################

# Chapeter 8 : Efficiently write efficient code


# Code snippet #8.1: Profiling example

using Profile
function lAlgb(n)
 a = rand(n,n) # matrix initialisation with random numbers
 b = a + a     # matrix sum
 c = b * b     # matrix multiplication
end
@profile (for i = 1:100; lAlgb(1000); end)
Profile.print()


# Code snippet #8.2: Type stable/unstable functions

using BenchmarkTools
function fUnstable(s::AbstractString, n)
    # This returns the type that is given in parameter `s` as a text string:
    T = getfield(Base, Symbol(s))
    x = one(T)
    for i in 1:n
        x = x+x
    end
    return x
end
function fStable(s::AbstractString, n)
    T = getfield(Base, Symbol(s))
    x = one(Float64)
    for i in 1:n
        x = x+x
    end
    return x
end
@code_warntype fUnstable("Float64",100000)
@code_warntype fStable("Float64",100000)
@benchmark fUnstable("Float64",100000) # median time:   1.299 ms
@benchmark fStable("Float64",100000)   # median time: 111.461 μs


# Code snippet #8.3: Matrix loops

using BenchmarkTools
M = rand(2000,2000)
function sumRowCol(M) # slower
    s = 0.0
    for r in 1:size(M)[1]
        for c in 1:size(M)[2]
            s += M[r,c]
        end
    end
    return s
end
function sumColRow(M) # faster
    s = 0.0
    for c in 1:size(M)[2]
        for r in 1:size(M)[1]
            s += M[r,c]
        end
    end
    return s
end
@benchmark sumRowCol(M) # median time:      21.684 ms
@benchmark sumColRow(M) # median time:      4.787 ms


# Code snippet #8.4: Managing processes

using Distributed
wksIDs = addprocs(3) # 2,3,4
println("Worker pids: ")
for pid in workers()
    println(pid) # 2,3,4
end
rmprocs(wksIDs[2]) # or rmprocs(workers()[2]) remove process pid 3
println("Worker pids: ")
for pid in workers()
    println(pid) # 2,4 left
end
@everywhere println(myid()) # 2,4


# Code snippet #8.5: Run heavy tasks in parallel

using Distributed, BenchmarkTools
a = rand(1:35,100)
@everywhere function fib(n)
    if n == 0 return 0 end
    if n == 1 return 1 end
    return fib(n-1) + fib(n-2)
end
@benchmark results = map(fib,a)  # serialised: median time:   490.473 ms
@benchmark results = pmap(fib,a) # parallelised: median time: 249.295 ms


# Code snippet #8.6: Divide and Conquer

using Distributed, BenchmarkTools
function f(n)
  s = 0.0
  for i = 1:n
    s += i/2
  end
    return s
end
function pf(n)
  s = @distributed (+) for i = 1:n # aggregate using sum on variable s
        i/2                        # last element of for cycle is used by the aggregator
  end
  return s
end
@benchmark  f(10000000) # median time:      11.478 ms
@benchmark pf(10000000) # median time:      4.458 ms

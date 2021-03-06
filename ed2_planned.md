# Ideas for a possible second edition of *Julia Quick Syntax Reference*

_Please either note your idea (or wishlist) for subjects to be included in a possible second edition of this book directly on this file (clone the repository -> make your modification -> make a pull request) or write a note using the forum on [julia-book.com](https://julia-book.com)._


## Extend discussion on packages to better describe modules and their relation with packages

- Add the following check if a package is already installed: `using Pkg; haskey(Pkg.dependencies(), Base.UUID("UUIDOfMyPackage"))`
- modules/submodule/export reexport: https://github.com/simonster/Reexport.jl


## New chapter (or section) to _create and register_ packages ? (but maybe out of scopus for a beginner book? )

https://julialang.github.io/Pkg.jl/v1/creating-packages/

Tagbot: https://github.com/marketplace/actions/julia-tagbot
Create a file at .github/workflows/TagBot.yml with the following contents:

```
name: TagBot
on:
  schedule:
    - cron: 0 0 * * *
jobs:
  TagBot:
    runs-on: ubuntu-latest
    steps:
      - uses: JuliaRegistries/TagBot@v1
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
```
Be sure that the dependency packages in the Prtoject.toml file, under the [compat] section, are UPPER bounded (see [here](https://github.com/JuliaRegistries/General))

Use [CompactHelper.jl](https://github.com/bcbi/CompatHelper.jl) to keep on sync the upper versions of your dependency package with those released

Create a file at .github/workflows/CompatHelper.yml with the following contents:

```
name: CompatHelper

on:
  schedule:
    - cron: '00 00 * * *'

jobs:
  CompatHelper:
    runs-on: ubuntu-latest
    steps:
      - name: Pkg.add("CompatHelper")
        run: julia -e 'using Pkg; Pkg.add("CompatHelper")'
      - name: CompatHelper.main()
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          COMPATHELPER_PRIV: ${{ secrets.COMPATHELPER_PRIV }}
        run: julia -e 'using CompatHelper; CompatHelper.main()'
```

Use [Registrator.jl](https://github.com/JuliaRegistries/Registrator.jl)

Click "Install the app".

Comment `@JuliaRegistrator register` on the commit/branch you want to register, with a section labeled "Release notes:" or "Patch notes:" to your Registrator trigger issue/comment, just after the @JuliaRegistrator trigger. For example,

```
@JuliaRegistrator register

Release notes:

These are the notes of the release, bla bla...
```


If you did follow the [registration guideline](https://github.com/JuliaRegistries/RegistryCI.jl#automatic-merging-guidelines) the package will be automatically registered.

## Add a section on package documentation and in particular on hosting it:
https://juliadocs.github.io/Documenter.jl/stable/man/hosting/#Hosting-Documentation-1

## Add a section to Ch05 - Input/Output to use [JDF.jl](https://github.com/xiaodaigh/JDF.jl) for saving and loading dataframes
## Add to Ch05 - Input/Output a reference to writedlm (maybe postponing CSV to dataframes discussion)
## Add a section on Dates/Times types
## Add a section on the new Thread API

### Paralellisation using multiple threads

(Example changed from @spawn macro on commit of 26.August.2020)

Here is an example on how to use the new @spawn macro in Julia >= 1.3threads on a function that produces something, saving the results to a vector where order doesn't matter and the computational process of any record is independent from those of any other record.


```
using BenchmarkTools

function inner(x)
    s = 0.0
    for i in 1:x
        for j in 1:i
            if j%2 == 0
                s += j
            else
                s -= j
            end
        end
    end
    return s
end

function parentSingleThread(x,y)
    toTest = x .+ (1:y)
    out = zeros(length(toTest))
    for i in 1:length(toTest)
        out[i] = inner(toTest[i])
    end
    return out
end
function parentThreaded(x,y)
    toTest = x .+ (1:y)
    out = zeros(length(toTest))
    Threads.@threads for i in 1:length(toTest)
        out[i] = inner(toTest[i])
    end
    return out
end


x = 100
y = 20

str = parentSingleThread(x,y)
mtr = parentThreaded(x,y)   

str == mtr # true
Threads.nthreads() # 4 in my case
@benchmark parentSingleThread(100,20) # 144 μs
@benchmark parentThreaded(100,20)     #  56 μs
```

Add threads to Julia: use the environmental variable JULIA_NUM_THREADS or start Julia with the command line option --threads. 


## Discute the variable keword argument with the following example:

```
function f2(val, kw1, kw2)
    return (val+1+kw1)/kw2
end
f2(val; kw1, kw2) = f2(val, kw1, kw2)
f2(2,3,4)
f2(2,kw2=4,kw1=3)
function f3(val, kw3)
    return (val+1+kw3)
end
f3(val; kw3) = f3(val, kw3)
f3(2,3)
f3(2,kw3=3)
function f4(val)
    return (val+1)
end
f4(2)

function f1(fname,val;kwargs...)
    return fname(val;kwargs...)
end
f1(f2,2,kw1=3,kw2=4)
f1(f2,2,kw2=4,kw1=3)
f1(f4,2)
```

## Replace the example on type instability with this one:

```
function f1(x)    
    if x == 0
        return 0
    else
        return 1.0
    end
end


function f2(x)    
    if x == 0
        return 0.0
    else
        return 1.0
    end
end

a = f1(0)
typeof(a)
b = f1(1)
typeof(b)
c = f2(0)
typeof(c)
d = f2(1)
typeof(d)

using BenchmarkTools
@benchmark f1(20)
@benchmark f2(20)

@code_warntype f1(20) # union



function f1(x)    
    resultMap = Dict(0 => 0, 1=>1.0)
    if haskey(resultMap,x)
        return resultMap[x]
    else
        return 1.0
    end
end


function f2(x)    
    resultMap = Dict(0 => 0.0, 1=>1.0)
    if haskey(resultMap,x)
        return resultMap[x]
    else
        return 1.0
    end
end

a = f1(0)
typeof(a)
b = f1(1)
typeof(b)
c = f2(0)
typeof(c)
d = f2(1)
typeof(d)

using BenchmarkTools
@benchmark f1(20)
@benchmark f2(20)

@code_warntype f1(20) # any
```

## Discuss the following extra packages:

- Distributions
- Revise
- PackageCompiler
- https://github.com/pszufe/OpenStreetMapX.jl
- https://github.com/pszufe/OpenStreetMapXPlot.jl

## Miscelaneous:

- Add `count(predicate, myArray)`
- Add package [TableView](https://github.com/JuliaComputing/TableView.jl) to display Dfs and tables in Juno.. no.. now obsolete for VSCode
- Specify `while true ... end` for loops without conditions
- Add the following items to Section 8.3.1; "Introspection tools":
  - `@less myFunction(myArgs)`: Show the source code of the specific method invoked
  - `@edit myFunction(myArgs)`: Like `@loss` but it opens the source code in an editor
  - `@code_native expr`, `@code_llvm expr`, `@code_typed expr`, `@code_lowered expr`: Various low-level interpretation of expr (and no, `@code_source expr` for an expression defined in the REPL is not yet supported, but it may be in the future: https://github.com/JuliaLang/julia/issues/2625 )
  - `names(mymodule,all=false)`: List the exported (or all) objects of mudule myModule
- Add how to upgrade Julia versions without reinstall all packages: https://stackoverflow.com/a/63391099/1586860
- Move everything Juno related to VS Code
  
  







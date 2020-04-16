# Ideas for a possible second edition of *Julia Quick Syntax Reference*

_Please either note your idea (or wishlist) for subjects to be included in a possible second edition of this book directly on this file (clone the repository -> make your modification -> make a pull request) or write a note using the forum on [julia-book.com](https://julia-book.com)._


## Extend discussion on packages to better describe modules and their relation with packages

- Add the following check if a package is already installed: `using Pkg; haskey(Pkg.installed(), "NameOfMyPackage")`

## New chapter (or section) to _create and register_ packages ? (but maybe out of scopus for a beginner book? )
## Add a section to Ch05 - Input/Output to use [JDF.jl](https://github.com/xiaodaigh/JDF.jl) for saving and loading dataframes
## Add a section on Dates/Times types
## Add a section on the new Thread API
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

## Discuss the following extra packages:

- Distributions
- Revise
- PackageCompiler
- https://github.com/pszufe/OpenStreetMapX.jl
- https://github.com/pszufe/OpenStreetMapXPlot.jl

## Miscelaneous:

- Add `count(predicate, myArray)`
- Add package [TableView](https://github.com/JuliaComputing/TableView.jl) to display Dfs and tables in Juno
- Specify `while true ... end` for loops without conditions








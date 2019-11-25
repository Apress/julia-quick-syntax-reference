# Corrections and updates for *Julia Quick Syntax Reference*

_Please either note the error (or update) directly on the relevant section of this file (clone the repository -> make your modification -> make a pull request) or write a note using the forum on [julia-book.com](https://julia-book.com)._


## Ch01 - Getting started

### On **page xx** [Summary of error]:

Details of error here. Highlight key pieces in **bold**.



## Ch02 - Data types and structures


### On **page xx** [Summary of error]:

Details of error here. Highlight key pieces in **bold**.



## Ch03 - Control flow and functions

### On **page xx** [Summary of error]:

Details of error here. Highlight key pieces in **bold**.



## Ch04 - Custom types

### On **page xx** [Summary of error]:

Details of error here. Highlight key pieces in **bold**.



## Ch05 - Input/Output

### On **page xx** [Summary of error]:

Details of error here. Highlight key pieces in **bold**.



## Ch06 - Metaprogramming and macro

### On **page xx** [Summary of error]:

Details of error here. Highlight key pieces in **bold**.



## Ch07 - Interfacing Julia with other languages

### On **page xx** [Summary of error]:

Details of error here. Highlight key pieces in **bold**.



## Ch08 - Effectively write efficient code

### On **page xx** [Summary of error]:

Details of error here. Highlight key pieces in **bold**.



## Ch09 - Working with data

### On **page 152** the example for the section "Computing the cumulative Sum by Categories" doesn't use the latest DataFrame API:

The code for `dfCum` using the new API should be: 

```
dfCum = by(df,[:region,:product]) do subdf
   return (year = subdf.year, cumProd = cumsum(subdf.production))
end
```


## Ch10 - Mathematical Libraries

### On **page xx** [Summary of error]:

Details of error here. Highlight key pieces in **bold**.



## Ch11 - Utilities

### On **page xx** [Summary of error]:

Details of error here. Highlight key pieces in **bold**.


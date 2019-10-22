################################################################################
# Code snippets of the book:
# A. Lobianco (2019) Julia Quick Syntax Reference - A Pocket Guide for Data
# Science Programming, Apress
# https://doi.org/10.1007/978-1-4842-5190-4
# Licence: Open Domain
################################################################################

# Chapeter 9 : Working with data


# Code snippet #9.1: Create the example DataFrame

using DataFrames
df = DataFrame(region      = ["US","US","US","US","EU","EU","EU","EU"],
               product     = ["Hardwood","Hardwood","Softwood","Softwood","Hardwood","Hardwood","Softwood","Softwood"],
               year        = [2010,2011,2010,2011,2010,2011,2010,2011],
               production  = [3.3,3.2,2.3,2.1,2.7,2.8,1.5,1.3],
               consumption = [4.3,7.4,2.5,9.8,3.2,4.3,6.5,3.0])


# Code snippet #9.2: Create an IndexedTable

using IndexedTables
myTable = ndsparse((
            region      = ["US","US","US","US","EU","EU","EU","EU"],
            product     = ["Hardwood","Hardwood","Softwood","Softwood","Hardwood","Hardwood","Softwood","Softwood"],
            year        = [2011,2010,2011,2010,2011,2010,2011,2010]
          ),(
            production  = [3.3,3.2,2.3,2.1,2.7,2.8,1.5,1.3],
            consumption = [4.3,7.4,2.5,9.8,3.2,4.3,6.5,3.0]
         ))


# Code snippet #9.3: Piping operations

using Pipe
add6(a) = a+6; div4(a) = a/4;
# Method #1, temporary variables:
a = 2;
b = add6(a);
c = div4(b);
println(c) # Output: 2
# Method 2, chained function calls:
println(div4(add6(a)))
# Method 3, using pipe
a |> add6 |> div4 |> println

addX(a,x) = a+x; divY(a,y) = a/y
a = 2
# With temporary variables:
b = addX(a,6)
c = divY(a,4)
d = b + c
println(c)
# With @pipe:
@pipe a |> addX(_,6) + divY(4,_) |> println # Output: 10.0`

data = (2,6,4)
# With temporary variables:
b = addX(data[1],data[2]) # 8
c = divY(data[1],data[3]) # 0.5
d = b + c     # 8.5
println(c)
# With @pipe:
@pipe data |> addX(_[1],_[2]) + divY(_[1],_[3]) |> println


# Code snippet #9.4: Plotting a function under different backends

using Plots
plot(cos,-4pi,4pi, label="Cosine function (GR)") # Plot using the default GR backend
pyplot()
plot(cos,-4pi,4pi, label="Cosine function (PyPlot)")
plotlyjs()
plot(cos,-4pi,4pi, label="Cosine function (PlotlyJS)")


# Code snippet #9.5: Plotting multiple series

using Plots
x = ["a","b","c","d","e",]
y = rand(5,3)
plot(x,y[:,1], seriestype=:bar)
plot!(x,y[:,2], seriestype=:line)
plot!(x,y[:,3], seriestype=:scatter)

# Code snippet #9.6: Plotting from a dataframe

using DataFrames, StatsPlots
# Let's use a modified version of our example data with more years and just one region:
df = DataFrame(
  product       = ["Softwood","Softwood","Softwood","Softwood","Hardwood","Hardwood","Hardwood","Hardwood"],
  year        = [2010,2011,2012,2013,2010,2011,2012,2013],
  production  = [120,150,170,160,100,130,165,158],
  consumption = [70,90,100,95,   80,95,110,120]
)
pyplot()
mycolours = [:green :orange] # note it's a row vector and the colours of the series will be alphabetically ordered whatever order we give it here
@df df plot(:year, :production, group=:product, linestyle = :solid, linewidth=3, label=reshape(("Production of " .* sort(unique(:product))) ,(1,:)), color=mycolours)
@df df plot!(:year, :consumption, group=:product, linestyle = :dot, linewidth=3, label =reshape(("Consumption of " .* sort(unique(:product))) ,(1,:)), color=mycolours)

################################################################################
# Code snippets of the book:
# A. Lobianco (2019) Julia Quick Syntax Reference - A Pocket Guide for Data
# Science Programming, Apress
# https://doi.org/10.1007/978-1-4842-5190-4
# Licence: Open Domain
################################################################################

# Chapeter 7 : Interfacing Julia with other languages


# Code snippet #7.1: Embedding C++

using Cxx
# Define the C++ function and compile it
cxx"""
#include<iostream>
void myCppFunction() {
   int a = 10;
   std::cout << "Printing " << a << std::endl;
}
"""
# Execute it
icxx"myCppFunction();" # Return "Printing 10"
# OR
# Convert the C++ to Julia function
myJuliaFunction() = @cxx myCppFunction()
# Run the function
myJuliaFunction() # Return "Printing 10"

cxx"""
#include<iostream>
int myCppFunction2(int arg1) {
   return arg1+1;
}
"""
juliaValue = icxx"myCppFunction2(9);" # 10
# OR
myJuliaFunction2(arg1) = @cxx myCppFunction2(arg1)
juliaValue = myJuliaFunction2(99)     # 100

cxx"""
#include <vector>
using namespace std;
vector<double> rowAverages (vector< vector<double> > rows) {
  // Compute average of each row..
  vector <double> averages;
  for (int r = 0; r < rows.size(); r++){
    double rsum = 0.0;
    double ncols= rows[r].size();
    for (int c = 0; c< rows[r].size(); c++){
      rsum += rows[r][c];
    }
    averages.push_back(rsum/ncols);
  }
  return averages;
}
"""
rows_julia = [[1.5,2.0,2.5],[4,5.5,6,6.5,8]]
rows_cpp   = convert(cxxt"vector< vector< double > > ", rows_julia)
rows_avgs  = collect(icxx"rowAverages($rows_cpp);")
# OR
rowAverages(rows) = @cxx rowAverages(rows)
rows_avgs  = collect(rowAverages(rows_cpp))


# Code snippet #7.2: Embedding Python

using PyCall
py"""
def sumMyArgs (i, j):
  return i+j
def getNElement (n):
  a = [0,1,2,3,4,5,6,7,8,9]
  return a[n]
"""
a = py"sumMyArgs"(3,4)          # 7
b = py"sumMyArgs"([3,4],[5,6])  # [8,10]
typeof(b)                       # Array{Int64,1}
c = py"sumMyArgs"([3,4],5)      # [8,9]
d = py"getNElement"(1)          # 1


# Code snippet #7.3: Using Python libraries

using PyCall
const ez = pyimport("ezodf")  # Equiv. of Python `import ezodf as ez`
destDoc = ez.newdoc(doctype="ods", filename="anOdsSheet.ods")
sheet = ez.Sheet("Sheet1", size=(10, 10))
destDoc.sheets.append(sheet)
dcell1 = get(sheet,(2,3)) # Equiv. of Python `dcell1 = sheet[(2,3)]`. This is cell "D3" !
dcell1.set_value("Hello")
get(sheet,"A9").set_value(10.5) # Equiv. of Python `sheet['A9'].set_value(10.5)`
destDoc.backup = false
destDoc.save()


# Code snippet #7.4: Embedding R

using RCall
R"""
sumMyArgs <- function(i,j) i+j
getNElement <- function(n) {
  a <- c(0,1,2,3,4,5,6,7,8,9)
  return(a[n])
}
"""
i = [3,4]
a = rcopy(R"sumMyArgs"(3,4))       # 7
b = rcopy(R"sumMyArgs"(i,[5,6]))   # [8,10]
b = rcopy(R"sumMyArgs($i,c(5,6))") # [8.0,10.0] (alternative)
c = rcopy(R"sumMyArgs"([3,4],5))   # [8,9]
d = rcopy(R"getNElement"(1))       # 0


# Code snippet #7.5: Using R libraries

using RCall, DataFrames
mydf = DataFrame(deposit = ["London","Paris","New-York","Hong-Kong"]; q =  [3,2,5,3] )  # Create a DataFrame ( a tabular structure with named cols) in Julia
R"""
  install.packages('ggplot2', repos='http://cran.us.r-project.org')
  library(ggplot2)
  ggplot($mydf, aes(x = q)) +
  geom_histogram(binwidth=1)
  """

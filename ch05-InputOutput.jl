################################################################################
# Code snippets of the book:
# A. Lobianco (2019) Julia Quick Syntax Reference - A Pocket Guide for Data
# Science Programming, Apress
# https://doi.org/10.1007/978-1-4842-5190-4
# Licence: Open Domain
################################################################################

# Chapeter 5 : Input-Output


# Code snippet #5.1: Retrive user input

function getUserInput(T=String,msg="")
  print("$msg ")
  if T == String
      return readline()
  else
    try
      return parse(T,readline())
    catch
     println("Sorry, I could not interpret your answer. Please try again")
     getUserInput(T,msg)
    end
  end
end

sentence = getUserInput(String,"Which sentence do you want to be repeated?");
n        = getUserInput(Int64,"How many times do you want it to be repeated?");
[println(sentence) for i in 1:n]
println("Done!")

# Code snippet #5.2: JSON import

using JSON2
jsonString="""
{
     "species": "Oak",
    "latitude": 53.204199,
   "longitude": -1.072787,
       "trees": [
                  {
                     "vol": 23.54,
                      "id": 1
                  },
                  {
                     "vol": 12.25,
                      "id": 2
                  }
                ]
}
"""
struct ForestStand
    sp::String
    lat::Float64
    long::Float64
    trees::Array{Dict{String,Float64},1}
end
nottFor = JSON2.read(jsonString, ForestStand)


# Code snippet #5.3: Write vs print

import Base.print # Needed when we want to override the print function
struct aCustomType
    x::Int64
    y::Float64
    z::String
end
foo = aCustomType(1,2,"MyObj")
print(foo) # Output: aCustomType(1, 2.0, "MyObj")
println(foo) # Output: aCustomType(1, 2.0, "MyObj") + NewLine
write(stdout,foo) # Output: MethodError
function print(io::IO, c::aCustomType)
    print("$(c.z): x: $(c.x), y: $(c.y)")
end
print(foo) # Output: MyObj: x: 1, y: 2.0
println(foo) # Output: MyObj: x: 1, y: 2.0 + NewLine (no need to override also `println()``)

# Code snippet #5.4: Export to Excel

using XLSX
XLSX.openxlsx("myExcelFile.xlsx", mode="w") do xf # w to write (or overwrite) the file
    sheet1 = xf[1]  # One sheet is created by default
    XLSX.rename!(sheet1, "new sheet 1")
    sheet2 = XLSX.addsheet!(xf, "new sheet 2") # We can add further sheets if needed
    sheet1["A1"] = "Hello world!"
    sheet2["B2"] = [ 1 2 3 ; 4 5 6 ; 7 8 9 ] # Top-right cell to anchor the matrix
end
XLSX.openxlsx("myExcelFile.xlsx", mode="rw") do xf # rw to append to an existing file instead
    sheet1 = xf[1]  # One sheet is created by default
    sheet2 = xf[2]
    sheet3 = XLSX.addsheet!(xf, "new sheet 3") # We can add further sheets if needed
    sheet1["A2"] = "Hello world again!"
    sheet3["B2"] = [ 10 20 30 ; 40 50 60 ; 70 80 90 ] # Top-right cell to anchor the matrix
end

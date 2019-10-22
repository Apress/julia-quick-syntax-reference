################################################################################
# Code snippets of the book:
# A. Lobianco (2019) Julia Quick Syntax Reference - A Pocket Guide for Data
# Science Programming, Apress
# https://doi.org/10.1007/978-1-4842-5190-4
# Licence: Open Domain
################################################################################

# Chapeter 6 : Metaprogramming and macros


# Code snippet #6.1: Macros

macro customLoop(controlExpr,workExpr)
  return quote
    for i in $controlExpr
      $workExpr
    end
  end
end
a = 5
@customLoop 1:4 println(i)
@customLoop 1:a println(i)
@customLoop 1:a if i > 3 println(i) end
@customLoop ["apple", "orange", "banana"]  println(i)
@customLoop ["apple", "orange", "banana"]  begin print("i: "); println(i)  end
@macroexpand @customLoop 1:4 println(i)


# Code snippet #6.2: String macro

macro print8_str(mystr)
  limits = collect(1:8:length(mystr))
  for (i,j) in enumerate(limits)
    st = j
    en = i==length(limits) ? length(mystr) : j+7
    println(mystr[st:en])
  end
end
print8"123456789012345678"

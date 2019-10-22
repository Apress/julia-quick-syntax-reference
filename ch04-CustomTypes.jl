################################################################################
# Code snippets of the book:
# A. Lobianco (2019) Julia Quick Syntax Reference - A Pocket Guide for Data
# Science Programming, Apress
# https://doi.org/10.1007/978-1-4842-5190-4
# Licence: Open Domain
################################################################################

# Chapeter 4 : Custom types


# Code snippet #4.1: Structures

mutable struct MyOwnType
  field1
  field2::String
  field3::Int64
end
mutable struct MyOwnType2{T<:Number}
 field1
 field2::String
 field3::T
end
myObject = MyOwnType("something","something",10)
a = myObject.field3  # 10
myObject.field3 = 20 # only if myObject is a mutable struct
MyOwnType(field3 = 10, field1 = "something", field2 = "something") # Error!


# Code snippet #4.2: Abstract types and inheritance

abstract type MyOwnGenericAbstractType end
abstract type MyOwnAbstractType1 <: MyOwnGenericAbstractType end
abstract type MyOwnAbstractType2 <: MyOwnGenericAbstractType end
mutable struct AConcreteType1 <: MyOwnAbstractType1
  f1::Int64
  f2::Int64
end
mutable struct AConcreteType2 <: MyOwnAbstractType1
  f1::Float64
end
mutable struct AConcreteType3 <: MyOwnAbstractType2
  f1::String
end
o1 = AConcreteType1(2,10)
o2 = AConcreteType2(1.5)
o3 = AConcreteType3("aa")
function foo(a :: MyOwnGenericAbstractType)
  println("Default implementation: $(a.f1)")
end
foo(o1) # Default implementation: 2
foo(o2) # Default implementation: 1.5
foo(o3) # Default implementation: aa
function foo(a :: MyOwnAbstractType1)
  println("A more specialised implementation: $(a.f1*4)")
end
foo(o1) # A more specialised implementation: 8
foo(o2) # A more specialised implementation: 6.0
foo(o3) # Default implementation: aa
function foo(a :: AConcreteType1)
     println("A even more specialised implementation: $(a.f1 + a.f2)")
end
foo(o1) # A even more specialised implementation: 12
foo(o2) # A more specialised implementation: 6.0
foo(o3) # Default implementation: aa


# Code snippet #4.3: Object-oriented model

struct Shoes
   shoesType::String
   colour::String
end
struct Person
  myname::String
  age::Int64
end
struct Student
   p::Person
   school::String
   shoes::Shoes
end
struct Employee
   p::Person
   monthlyIncomes::Float64
   company::String
   shoes::Shoes
end
gymShoes = Shoes("gym","white")
proShoes = Shoes("classical","brown")
Marc = Student(Person("Marc",15),"Divine School",gymShoes)
MrBrown = Employee(Person("Brown",45),3200.0,"ABC Corporation Inc.", proShoes)
function printMyActivity(self::Student)
   println("Hi! I am $(self.p.myname), I study at $(self.school) school, and I wear $(self.shoes.colour) shoes")
end
function printMyActivity(self::Employee)
  println("Good day. My name is $(self.p.myname), I work at $(self.company) company and I wear $(self.shoes.colour) shoes")
end
printMyActivity(Marc)     # Hi! I am Marc, ...
printMyActivity(MrBrown)  # Good day. My name is MrBrown, ...

################################################################################
# Code snippets of the book:
# A. Lobianco (2019) Julia Quick Syntax Reference - A Pocket Guide for Data
# Science Programming, Apress
# https://doi.org/10.1007/978-1-4842-5190-4
# Licence: Open Domain
################################################################################

# Chapeter 10 : Mathematical libraries


# Code snippet #10.1: Numerically solve a linear problem

using CSV, JuMP, GLPK

# Define sets #
#  Sets
#      i   canning plants   / seattle, san-diego /
#      j   markets          / new-york, chicago, topeka / ;
plants  = ["seattle","san-diego"]          # canning plants
markets = ["new-york","chicago","topeka"]  # markets

# Define parameters #
#   Parameters
#       a(i)  capacity of plant i in cases
#         /    seattle     350
#              san-diego   600  /
a = Dict(              # capacity of plant i in cases
  "seattle"   => 350,
  "san-diego" => 600,
)

#       b(j)  demand at market j in cases
#         /    new-york    325
#              chicago     300
#              topeka      275  / ;
b = Dict(              # demand at market j in cases
  "new-york"  => 325,
  "chicago"   => 300,
  "topeka"    => 275,
)

# Table d(i,j)  distance in thousands of miles
#                    new-york       chicago      topeka
#      seattle          2.5           1.7          1.8
#      san-diego        2.5           1.8          1.4  ;
d_table = CSV.read(IOBuffer("""
plants     new-york  chicago  topeka
seattle    2.5       1.7      1.8
san-diego  2.5       1.8      1.4
"""),delim=" ", ignorerepeated=true, copycols=true)
d = Dict( (r[:plants],m) => r[Symbol(m)] for r in eachrow(d_table), m in markets)
# Here we are converting the table in a "(plant, market) => distance" dictionary
# r[:plants]:   the first key, using the cell at the given row and `plants` field
# m:            the second key
# r[Symbol(m)]: the value, using the cell at the given row and the `m` field

# Scalar f  freight in dollars per case per thousand miles  /90/ ;
f = 90 # freight in dollars per case per thousand miles

# Parameter c(i,j)  transport cost in thousands of dollars per case ;
#            c(i,j) = f * d(i,j) / 1000 ;
# We first declare an empty dictionary and then we fill it with the values
c = Dict() # transport cost in thousands of dollars per case ;
[ c[p,m] = f * d[p,m] / 1000 for p in plants, m in markets]

# Model declaration (transport model)
trmodel = Model(with_optimizer(GLPK.Optimizer,msg_lev=GLPK.MSG_ON)) # we choose GLPK with a verbose output

## Define variables ##
#  Variables
#       x(i,j)  shipment quantities in cases
#       z       total transportation costs in thousands of dollars ;
#  Positive Variable x ;
@variables trmodel begin
    x[p in plants, m in markets] >= 0 # shipment quantities in cases
end

## Define contraints ##
# supply(i)   observe supply limit at plant i
# supply(i) .. sum (j, x(i,j)) =l= a(i)
# demand(j)   satisfy demand at market j ;
# demand(j) .. sum(i, x(i,j)) =g= b(j);
@constraints trmodel begin
    supply[p in plants],   # observe supply limit at plant p
        sum(x[p,m] for m in markets)  <=  a[p]
    demand[m in markets],  # satisfy demand at market m
        sum(x[p,m] for p in plants)   >=  b[m]
end

# Objective
@objective trmodel Min begin
    sum(c[p,m]*x[p,m] for p in plants, m in markets)
end

print(trmodel) # The model in mathematical terms is printed

optimize!(trmodel)

status = termination_status(trmodel)

if (status == MOI.OPTIMAL || status == MOI.LOCALLY_SOLVED || status == MOI.TIME_LIMIT) && has_values(trmodel)
    if (status == MOI.OPTIMAL)
        println("** Problem solved correctly **")
    else
        println("** Problem returned a (possibly suboptimal) solution **")
    end
    println("- Objective value (total costs): ", objective_value(trmodel))
    println("- Optimal routes:")
    optRoutes = value.(x)
    [println("$p --> $m: $(optRoutes[p,m])") for m in markets, p in plants]
    println("- Shadow prices of supply:")
    [println("$p = $(dual(supply[p]))") for p in plants]
    println("- Shadow prices of demand:")
    [println("$m = $(dual(demand[m]))") for m in markets]
else
    println("The model was not solved correctly.")
    println(status)
end

# Code snippet #10.2: Numerically solve a non-linear problem

using JuMP, Ipopt

m = Model(with_optimizer(Ipopt.Optimizer, print_level=0))

@variable(m, 0 <= p, start=1, base_name="Quantities of pizzas")
@variable(m, 0 <= s, start=1, base_name="Quantities of sandwiches")

@constraint(m, budget,     10p + 4s <=  80 )

@NLobjective(m, Max, 100*p - 2*p^2 + 70*s - 2*s^2 - 3*p*s)

optimize!(m)

status = termination_status(m)

if (status == MOI.OPTIMAL || status == MOI.LOCALLY_SOLVED || status == MOI.TIME_LIMIT) && has_values(m)
    if (status == MOI.OPTIMAL)
        println("** Problem solved correctly **")
    else
        println("** Problem returned a (possibly suboptimal) solution **")
    end
    println("- Objective value : ", objective_value(m))
    println("- Optimal solutions:")
    println("pizzas: $(value.(p))")
    println("sandwitches: $(value.(s))")
    println("- Dual (budget): $(dual.(budget))")
else
    println("The model was not solved correctly.")
    println(status)
end


# Code snippet #10.3: Analytically solve the same non-linear problem

using SymPy
@vars qₚ qₛ pₚ pₛ positive=true
@vars λ
utility = 100*qₚ - 2*qₚ^2 + 70*qₛ - 2*qₛ^2 - 3*qₚ*qₛ
budget  = pₚ* qₚ + pₛ*qₛ
lagr    = utility + λ*(80 - budget)
dlqₚ    = diff(lagr,qₚ)
dlqₛ    = diff(lagr,qₛ)
dlλ     = diff(lagr,λ)
sol     = sympy.solve([Eq(dlqₚ,0), Eq(dlqₛ,0), Eq(dlλ,0)],[qₚ, qₛ, λ])
qₚ_num  = sol[qₚ].evalf(subs=Dict(pₚ=>10,pₛ=>4)) # 4.64285714285714
qₛ_num  = sol[qₛ].evalf(subs=Dict(pₚ=>10,pₛ=>4)) # 8.39285714285714
λ_num   = sol[λ].evalf(subs=Dict(pₚ=>10,pₛ=>4))   # 5.625
z = utility.evalf(subs=Dict(qₚ=>qₚ_num, qₛ=>qₛ_num)) #750.892857142857

# Code snippet #10.4: Fitting data to a given model

using LsqFit,CSV,Plots
# **** Fit volumes to logistic model ***
@. model(age, pars) = pars[1] / (1+exp(-pars[2] * (age - pars[3])) )
obsVols = CSV.read(IOBuffer("""
age  vol
20   56
35   140
60   301
90   420
145  502
"""),delim=" ", ignorerepeated=true, copycols=true)
par0 = [600, 0.02, 60]
fit = curve_fit(model, obsVols.age, obsVols.vol, par0)
fit.param # [497.07, 0.05, 53.5]
fitX = 0:maximum(obsVols.age)*1.2
fitY  = [fit.param[1] / (1+exp(-fit.param[2] * (y - fit.param[3]) ) ) for y in fitX]
plot(fitX,fitY, seriestype=:line, label="Fitted values")
plot!(obsVols.age, obsVols.vol, seriestype=:scatter, label="Obs values")
plot!(obsVols.age, fit.resid, seriestype=:bar, label="Residuals")

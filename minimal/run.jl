import Pkg
Pkg.activate(".")
println("Depot: ", DEPOT_PATH)
println("Load: ", Base.load_path())
print(pwd())
using CSV
println("hello")
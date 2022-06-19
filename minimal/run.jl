import Pkg
Pkg.activate(".")
println("Depot: ", DEPOT_PATH)
println("Load: ", Base.load_path())
println(pwd())
println("try CSV")
using CSV
println("hello")
include("Include.jl")
using PyPlot

data_dictionary = maximize_acetate_data_dictionary(0,0,0)
# set the object
objective_coefficient_array = data_dictionary["objective_coefficient_array"]
#objective_coefficient_array[12] = -1.0  # Acetate
#objective_coefficient_array[41] = -1.0  # formate
#objective_coefficient_array[40] = -1.0  # ethanol
objective_coefficient_array[20] = -1.0  # ATP
#objective_coefficient_array[24] = -1.0 #biomass
data_dictionary["objective_coefficient_array"] = objective_coefficient_array

(objective_value, flux_array, dual_array, uptake_array, exit_flag) = FluxDriver(data_dictionary)

AtomString = collect("CHNOPS")  # atom balance check: C,H,N,O,P,S
AtomArray = generate_atom_matrix("./Atom.txt", data_dictionary)
AtomResidual = AtomArray'*data_dictionary["stoichiometric_matrix"]*flux_array
println("------Total Atom Balance--------")
for i = 1:length(AtomResidual)
  println("$(AtomString[i]) -> $(AtomResidual[i])")
end

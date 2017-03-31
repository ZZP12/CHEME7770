include("Include.jl")
using PyPlot

data_dictionary = DataDictionary(0,0,0)
AtomString = collect("CHNOPS")  # atom balance check: C,H,N,O,P,S
AtomArray = generate_atom_matrix("./Atom.txt", data_dictionary)

# analyze atom balance of each reaction
ListOfReactionStrings = data_dictionary["list_of_reaction_strings"]
NetAtomOfEachReaction = AtomArray'*data_dictionary["stoichiometric_matrix"]
(NumOfAtom, NumOfRnx) = size(NetAtomOfEachReaction)
SumNetAtomOfEachRnx = zeros(1, NumOfRnx)
unbcount = 0
for i = 1:NumOfRnx
  if (sum(abs(NetAtomOfEachReaction[:,i])) != 0)
    println("reaction$i "*ListOfReactionStrings[i]*" "*string(NetAtomOfEachReaction[:,i]))
    unbcount += 1
    for j = 1:6
      if (NetAtomOfEachReaction[j,i] != 0)
        println("    "*"$(AtomString[j]) -> $(NetAtomOfEachReaction[j,i])")
      end
    end
  end
end
println("Total unbalanced reactions $unbcount")

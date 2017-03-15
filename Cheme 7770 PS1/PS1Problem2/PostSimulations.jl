#zzp
# post-simulation
include("Include.jl")

# for Problem 2 a) i)dynamics ii)steady w/ inducer  b)Z([x3,x4], P)(time)
# Plot Time course of three proteins.
AdjSimu_P = readdlm("./AdjSimulation-P1.dat")  #dynamic
plot(AdjSimu_P[:,1], AdjSimu_P[:,8],AdjSimu_P[:,1], AdjSimu_P[:,9],AdjSimu_P[:,1], AdjSimu_P[:,10])
(norow, nocolumn) = size(AdjSimu_P)
timeAverageSensitivityMatrix = zeros(9, 24)
ZProtein3 = zeros(norow, 24)
magnitudeZProtein3 = zeros(24)
ZmRNA1 = zeros(norow, 24)
magnitudeZmRNA1 = zeros(24)
for i = 1:24
  AdjSimu_P = readdlm("./AdjSimulation-P"*string(i)*".dat")
  time_average_array_2333 = time_average_array(AdjSimu_P[:,1], AdjSimu_P[:,11:19])#for dynamics
#  time_average_array_2333 = AdjSimu_P[140,11:19] #for steady
  timeAverageSensitivityMatrix[:,i] = transpose(time_average_array_2333)
  ZProtein3[:,i] = AdjSimu_P[:,19] #sensitivity of Protein3 at every time point for parameter i
  magnitudeZProtein3[i] = sum(abs(AdjSimu_P[:,19]))
  ZmRNA1[:,i] = AdjSimu_P[:,14] #sensitivity of mRNA1 at every time point for parameter i
  magnitudeZmRNA1[i] = sum(abs(AdjSimu_P[:,14]))
end

# Sensitivity Matrix
dynamicSensitivityMatrix = zeros(9,24)
for i = 1:9
  for j = 1:24
    dynamicSensitivityMatrix[i,j] = timeAverageSensitivityMatrix[i,j]
  end
end
writedlm("./Adj_dynamicSensitivityMatrix.dat", dynamicSensitivityMatrix)  #for dynamic
#writedlm("./Steady_dynamicSensitivityMatrix.dat", dynamicSensitivityMatrix) #for steady
# U*diagm(S)*Vt; F[:U], F[:S], F[:V] and F[:Vt]
@show size(dynamicSensitivityMatrix)
UdynamicSensitivityMatrix = abs(svdfact(dynamicSensitivityMatrix, thin=false)[:U])
VtdynamicSensitivityMatrix = abs(svdfact(dynamicSensitivityMatrix, thin=false)[:Vt])
(nrow, ncol) = size(VtdynamicSensitivityMatrix)
VtDSM = zeros(nrow, ncol)
for i = 1:nrow
  for j = i:ncol
    VtDSM[i,j] = VtdynamicSensitivityMatrix[i,j]/maximum(VtdynamicSensitivityMatrix[i,:])
    if (VtDSM[i,j]>0.5)
      if (i!=j)
        print("P"*string(i)*"-P"string(j)*", ")
      else
        print("P"*string(j)*", ")
      end
    end
  end
end

# sentivity on mRNA1 and Protein3
println("\nmRNA1&Protein3")
magnitudeZmRNA1 = magnitudeZmRNA1/maximum(magnitudeZmRNA1)
magnitudeZProtein3 = magnitudeZProtein3/maximum(magnitudeZProtein3)
for i = 1:size(magnitudeZmRNA1,1)
  if (magnitudeZmRNA1[i]>0.1) | (magnitudeZProtein3[i]>0.1)
    print("P"*string(i)*", ")
  end
end

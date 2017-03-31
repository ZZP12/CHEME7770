include("Include.jl")
using PyPlot


# aerobic simulation
data_dictionary = maximize_cellmass_data_dictionary(0,0,0)
deltT = 0.1
stoptime = 9.0
totaltimepoint = length(collect(0:deltT:stoptime))
biomassX = zeros(totaltimepoint)
GlcTimeCourse = zeros(totaltimepoint)
AcTimeCourse = zeros(totaltimepoint)
# set up initial condition
GlcTimeCourse[1] = 11.0
biomassX[1] = 0.007
AcTimeCourse[1] = 0.3
nextdatadict = data_dictionary["species_bounds_array"]
for k = 2:totaltimepoint
  # update
  GluUptakerateBound = 10.5*GlcTimeCourse[k-1]/(GlcTimeCourse[k-1]+0.9)
  nextdatadict[81,:] = [min(-GluUptakerateBound,0.0), 0.0]
  data_dictionary["species_bounds_array"] = nextdatadict
  # solve the lp problem -
  (objective_value, flux_array, dual_array, uptake_array, exit_flag) = FluxDriver(data_dictionary)
  # record results
  AcTimeCourse[k] = AcTimeCourse[k-1] + (uptake_array[73]/(-objective_value))*biomassX[k-1]*(exp(-objective_value*deltT)-1)
  if (AcTimeCourse[k]<0) #the growth stops
    AcTimeCourse[k] = AcTimeCourse[k-1]
    nextdatadict[73,:] = [0.0, 0.0]
    biomassX[k] = biomassX[k-1]
  else
    biomassX[k] = biomassX[k-1]*exp(-objective_value*deltT)
  end
  GlcTimeCourse[k] = GlcTimeCourse[k-1] + (uptake_array[81]/(-objective_value))*biomassX[k-1]*(exp(-objective_value*deltT)-1)
end
#load experiment
aerobicDataX = readExperimentData("ExperimentData/Aerobic_X.csv")
aerobicDataGlc = readExperimentData("ExperimentData/Aerobic_Glc.csv")
aerobicDataAc = readExperimentData("ExperimentData/Aerobic_Ac.csv")
t = collect(0:deltT:stoptime)
subplot(2,2,1)
plot(t,biomassX, "r-", aerobicDataX[:,1],aerobicDataX[:,2],"g+")
title("X")
subplot(2,2,2)
plot(t,GlcTimeCourse, "r-", aerobicDataGlc[:,1],aerobicDataGlc[:,2],"g+")
title("Glc")
subplot(2,2,3)
plot(t,AcTimeCourse, "r-", aerobicDataAc[:,1],aerobicDataAc[:,2],"g+")
title("Ac")

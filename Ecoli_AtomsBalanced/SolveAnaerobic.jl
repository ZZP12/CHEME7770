include("Include.jl")
using PyPlot


# anaerobic simulation
data_dictionary = maximize_cellmass_data_dictionary(0,0,0)
deltT = 0.1
stoptime = 10.0
totaltimepoint = length(collect(0:deltT:stoptime))
biomassX = zeros(totaltimepoint)
GlcTimeCourse = zeros(totaltimepoint)
AcTimeCourse = zeros(totaltimepoint)
ForTimeCourse = zeros(totaltimepoint)
EthTimeCOurse = zeros(totaltimepoint)
# set up initial condition
GlcTimeCourse[1] = 10.5
biomassX[1] = 0.002
AcTimeCourse[1] = 0.0
ForTimeCourse[1] = 0.0
EthTimeCOurse[1] = 0.0
nextdatadict = data_dictionary["species_bounds_array"]
nextdatadict[89,:] = [0.0, 0.0] #turn off Oxygen

for k = 2:totaltimepoint
  # update
  GluUptakerate = 18.5*GlcTimeCourse[k-1]/(GlcTimeCourse[k-1]+0.9)
  nextdatadict[81,:] = [min(-GluUptakerate,0.0), 0.0]
  data_dictionary["species_bounds_array"] = nextdatadict
  # solve the lp problem -
  (objective_value, flux_array, dual_array, uptake_array, exit_flag) = FluxDriver(data_dictionary)
  # record results
  AcTimeCourse[k] = AcTimeCourse[k-1] + (uptake_array[73]/(-objective_value))*biomassX[k-1]*(exp(-objective_value*deltT)-1)
  biomassX[k] = biomassX[k-1]*exp(-objective_value*deltT)
  GlcTimeCourse[k] = GlcTimeCourse[k-1] + (uptake_array[81]/(-objective_value))*biomassX[k-1]*(exp(-objective_value*deltT)-1)
  ForTimeCourse[k] = ForTimeCourse[k-1] + (uptake_array[78]/(-objective_value))*biomassX[k-1]*(exp(-objective_value*deltT)-1)
  EthTimeCOurse[k] = EthTimeCOurse[k-1] + (uptake_array[77]/(-objective_value))*biomassX[k-1]*(exp(-objective_value*deltT)-1)
end
#load experiment
anaerobicDataX = readExperimentData("ExperimentData/Anaerobic_X.csv")
anaerobicDataGlc = readExperimentData("ExperimentData/Anaerobic_Glc.csv")
anaerobicDataAc = readExperimentData("ExperimentData/Anaerobic_Ac.csv")
anaerobicDataFor = readExperimentData("ExperimentData/Anaerobic_For.csv")
anaerobicDataEth = readExperimentData("ExperimentData/Anaerobic_Eth.csv")
#plot
t = collect(0:deltT:stoptime)
subplot(2,3,1)
  plot(t,biomassX, "r-", anaerobicDataX[:,1], anaerobicDataX[:,2],"g+")
  title("X")
subplot(2,3,2)
  plot(t,GlcTimeCourse, "r-", anaerobicDataGlc[:,1], anaerobicDataGlc[:,2],"g+")
  title("Glc")
subplot(2,3,3)
  plot(t,AcTimeCourse, "r-", anaerobicDataAc[:,1], anaerobicDataAc[:,2],"g+")
  title("Ac")
subplot(2,3,4)
  plot(t,ForTimeCourse, "r-", anaerobicDataFor[:,1], anaerobicDataFor[:,2],"g+")
  title("For")
subplot(2,3,5)
  plot(t,EthTimeCOurse, "r-", anaerobicDataEth[:,1], anaerobicDataEth[:,2],"g+")
  title("Eth")

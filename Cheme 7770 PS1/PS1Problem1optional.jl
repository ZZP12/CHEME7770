# open complex formation
using ODE
using PyPlot


function opensystem1(time,y)
time += 5.0
kobs = 0.01
RPopen = 1.0 - exp(-kobs*time)
KT = 1.0
kT = 50.0
ratedeg = 0.2;
rateabs = kT*RPopen/(KT+RPopen)
ucontrol = 1.0;
rateact = ucontrol*rateabs
dydt = rateact - ratedeg*y  #not a good one
return dydt
end
function opensystem2(time,y)
kobs = 0.01
RPopen = 1.0 - exp(-kobs*time)
KT = 1.0
kT = 50.0
ratedeg = 0.2;
rateabs = kT*RPopen/(KT+RPopen)
ucontrol = 1.0;
rateact = ucontrol*rateabs
dydt = rateact - ratedeg*y  #not a good one
return dydt
end

funopencomplex1(t,y) = opensystem1(t,y)
timepoint = collect(0.0:0.1:10.0)
(T,Y1) = ode45(funopencomplex1,0.0,timepoint;points=:specified)
funopencomplex2(t,y) = opensystem2(t,y)
(T,Y2) = ode45(funopencomplex2,0.0,timepoint;points=:specified)
plot(T,Y1,T,Y2)

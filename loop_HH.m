% script to numerically simulate the HH model
% calls function HHEquations.m which must be in same directory as this file

% set simulation timespan in ms
tspan = [0 1100];

% set initial conditions [V(t=0); m(t=0); h(t=0); n(t=0)]
v0 = -64.9997;
m0 = 0.0529;
h0 = 0.5961;
n0 = 0.3176;
ICs = [v0; m0; h0; n0];

pulsei_vec = 8:40;
freq_vec = zeros(1,size(pulsei_vec,2));

% set applied current pulse
basei = 0.0;   % baseline applied current
t_on = 100;    % time that current pulse turns on
t_off = 1000;  % time that current pulse turns off

for i = 1:length(pulsei_vec)
    pulsei = pulsei_vec(i);
    
    disp(i)
    % set up for simulation
    options = odeset('MaxStep',1);
    HHEquations_ftn = @(t,vars)HodHuxEquations(t, vars, basei, pulsei, t_on, t_off);
    
    % Call the ODE solver ode15s to numerically simulate
    [t,vars] = ode15s(HHEquations_ftn, tspan, ICs, options);
    
    % output: t = time stamp vector of size [j by 1]. vars = [j by 4] matrix with
    % column 1 = voltage Vm, column 2 = m, column 3 = h, column 4 = n
    Vm = vars(:,1);
    m = vars(:,2);
    h = vars(:,3);
    n = vars(:,4);
    
    % determine spike times and interspike intervals
    [peaks, indxs]=findpeaks(Vm,'MINPEAKHEIGHT',-10);
    spiketimes=t(indxs);
    spikeintervals=diff(spiketimes);
    freq = 1/(mean(spikeintervals)/1000);
    
    freq_vec(i) = freq;
end

% plot Voltage vs time
%figure(1)
%plot(t,Vm,spiketimes,peaks,'*')

figure(2)
plot(pulsei_vec,freq_vec,'ko-')
xlabel('Current (nA)')
ylabel('Frequency (Hz)')




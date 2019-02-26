% This file plots the DC Motor velocity obtained from the
% serial plot window from the Sampling and Data Acquisition experiment. 


% Experiment time
t = 0:Ts:Ts*(length(WindowDat)-1);

%Velocity Plot Generation
if Ts > 0.05
    figure;plot(t,WindowDat,'-o')
    title('Motor Velocity')
    xlabel('time (secs)')
    ylabel('Counts')
    grid on
    
else
    figure;plot(t,WindowDat,'o')
    title('Motor Velocity')
    xlabel('time (secs)')
    ylabel('Counts')
    grid on
    
end

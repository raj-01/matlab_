%% calculating power comsumption in iot devices 

function power_consumption( dev1 , dev2 , dev3)
    % width of each pulse is 1/baude_rate 
    % number of total data points in a pulse = (1/baude_rate)/(1/(4*f_sampling)) = (4*f_sampling)/baude_rate
    power(1) = sum( dev1.^2 );
    power(2) = sum( dev1.^2 ) + sum(dev2.^2) ;
    power(3) = sum( dev1.^2 ) + sum(dev2.^2) + sum(dev3.^2);
    
    stem(power,'rO');
    title('Power Consumption in IOT dev Vs Number of IOT dev');
    xlabel('Number of IOT dev');
    ylabel('Power Comsumption');
end 
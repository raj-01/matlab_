% class to get pulse maping from bits 
%  t = 0:1/(4*f):length(cdma_data)/baude_rate
% i.e width of one pulse 1/baude_rate and in that we have
% 0:1/(4*f):1/baude_rate data 
% also , len(t)----> total length of sin we want , Let L be the boundary 
% so , L/(1/(4*f)) = len(t) 
classdef pulse
    properties
        baude_rate
        f_samp 
        len_cdma_data
    end
    methods
        function self = pulse(baude_rate,f_samp , len_cdma_data)
            self.baude_rate = baude_rate ;
            self.f_samp= f_samp ;
            self.len_cdma_data = len_cdma_data;
        end
        function maped_val = square(self,val)
                maped_val = val.*( ones(1,ceil((4*self.f_samp)/self.baude_rate)));
        end
        function maped_val = my_sinc( self , val )
            t = -1/(2*self.baude_rate):1/(4*self.f_samp):1/(2*self.baude_rate) ;
            maped_val = val.*( sinc(t));
        end
    end
end
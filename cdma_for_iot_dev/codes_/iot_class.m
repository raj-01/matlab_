% class includes all the fucntions requred by sending iot_dev 
classdef iot_class
     properties
         walsh_code 
         f_samp
         freq
         baude_rate
     end 
     methods
        function self = iot_class(walsh_code,f_samp,freq,baude_rate)
                if nargin  > 0 
                    self.walsh_code = walsh_code ;
                    self.f_samp = f_samp ;
                    self.freq = freq ;
                    self.baude_rate = baude_rate;
                end
        end
     % bits to symbol conversion 
        function [sym_data_I , sym_data_Q] = bits_to_sym(self ,data)
                sym_data_I = [];
                find_sym = find_class() ;
                sym_data_Q = [] ; 
                for i=1:4:length(data)
                    [I , Q] = find_sym.bits_to_sym(data(i:(i+4-1)));
                    sym_data_I = [sym_data_I , I] ;
                    sym_data_Q = [sym_data_Q , Q] ;
                end
        end 
                
     % cdma class 
        function cdma_data = cdma(self, raw_data)
                walsh_code_ = self.walsh_code;
                cdma_data = raw_data(1)*walsh_code_;
                for i =  2:length(raw_data)
                    cdma_data = [ cdma_data , raw_data(i)*walsh_code_];    
                end 
        end
     % pulse maping  
         function pulse_maped = bits_to_pulse(self , cdma_data)
                pulse_ = pulse(self.baude_rate,self.f_samp,length(cdma_data));
                pulse_maped = pulse_.my_sinc(cdma_data(1));
             for i=2:length(cdma_data)
                 pulse_maped = [pulse_maped,pulse_.my_sinc(cdma_data(i))];
             end 
         end
     % fdma function 
     function  fdma_maped = fdma_I(self ,bits_to_pulse)
         t= 0:1/(4*self.f_samp):(length(bits_to_pulse)/(4*self.f_samp)-1/(4*self.f_samp));      %  smapling freq is 4 times the freq  
         fdma_maped = (cos(2*pi*(self.freq).*t)).*bits_to_pulse;
     end
      function  fdma_maped = fdma_Q(self ,bits_to_pulse)
         t= 0:1/(4*self.f_samp):(length(bits_to_pulse)/(4*self.f_samp)-1/(4*self.f_samp));      %  smapling freq is 4 times the freq  
         fdma_maped = (sin(2*pi*(self.freq).*t)).*bits_to_pulse;
     end
     end
end
    
    
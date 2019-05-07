classdef  find_class
    properties 
    end 
methods 
    function  [sym_I , sym_Q] = bits_to_sym(self , data )
        if( data == [0 0 0 1]) 
            sym_I = 1 ; sym_Q = -1 ;
        elseif( data == [0 0 1 0] )
            sym_I = 1 ; sym_Q = 3 ;
        elseif( data == [0 0 1 1])
            sym_I = 1 ; sym_Q = -3 ;
        elseif( data == [0 1 0 0]) 
            sym_I = -1 ; sym_Q = 1 ;
        elseif( data == [0 1 0 1])
            sym_I = -1 ; sym_Q = -1 ;
        elseif( data == [0 1 1 0])
            sym_I = -1 ; sym_Q = 3 ;
        elseif( data == [0 1 1 1]) 
            sym_I = -1 ; sym_Q = -3 ;
        elseif( data == [1 0 0 0])
            sym_I = 3 ; sym_Q = 1 ;
        elseif( data == [1 0 0 1])
            sym_I = 3 ; sym_Q = -1 ;
        elseif( data == [1 0 1 0])
            sym_I = 3 ; sym_Q = 3 ;
        elseif( data == [1 0 1 1])
            sym_I = 3 ; sym_Q = -3 ;
        elseif( data == [1 1 0 0] )
            sym_I = -3 ; sym_Q = 1 ;
        elseif( data == [1 1 0 1])
            sym_I = -3 ; sym_Q = -1 ;
        elseif( data == [1 1 1 0] )
            sym_I = -3 ; sym_Q = 3 ;
        elseif( data == [ 1 1 1 1])
            sym_I = -3 ; sym_Q = -3 ;
        else
            sym_I = 1 ; sym_Q = 1 ;
        end 
    end
    function data = sym_to_bits(self, I , Q)
        if( [I,Q] == [1,-1] ) 
            data = [0 0 0 1];
        elseif( [I,Q] == [1,3])
            data = [0 0 1 0];
        elseif( [I,Q] == [1,-3])
            data = [0 0 1 1];
        elseif( [I,Q] == [-1,1])
            data = [0 1 0 0];
        elseif( [I,Q] == [-1,-1])
            data = [0 1 0 1];
        elseif( [I,Q] == [-1,3])
            data = [0 1 1 0];
        elseif( [I,Q] == [-1,-3])
            data = [0 1 1 1];
        elseif( [I,Q] == [3,1])
            data = [1 0 0 0];
        elseif( [I,Q] == [3,-1])
            data = [1 0 0 1];
        elseif( [I,Q] == [3,3])
            data = [1 0 1 0];
        elseif( [I,Q] == [3,-3])
            data = [1 0 1 1];
        elseif( [I,Q] == [-3,1])
            data = [1 1 0 0];
        elseif( [I,Q] == [-3,-1])
            data = [1 1 0 1];
        elseif( [I,Q] == [-3,3])
            data = [1 1 1 0];
        elseif( [I,Q] == [-3,-3])
            data = [ 1 1 1 1];
        else 
            data = [0 0 0 0];
        end     
    end
             
end 
end 












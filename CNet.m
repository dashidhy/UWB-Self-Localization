classdef CNet < handle
        
    properties
        
        Num_nodes = 0;
        Dim = 0;
        
        Noise_std = 0;
        Range = 0;
        Loc_gt = [];
        Bias = 0;
        
        Index_anchor = [];
        Loc_anchor = [];
        M = [];
        
        Loc_cp = [];
    
    end
    
    methods
        
        function obj = CNet(Num_nodes, Dim)
            
            obj.Num_nodes = Num_nodes;
            obj.Dim = Dim;
        
        end
        
        function Reset(obj, Num_nodes, Dim)
            
            obj.Num_nodes = Num_nodes;
            obj.Dim = Dim;
            
            obj.Noise_std = 0;
            obj.Range = 0;
            obj.Loc_gt = [];
            obj.Bias = 0;
            
            obj.Index_anchor = [];
            obj.Loc_anchor = [];
            obj.M = [];
            
            obj.Loc_cp = [];
        
        end
        
        function [iter, time] = Simulate(obj, Noise_std, Range)
            
            obj.Noise_std = Noise_std;
            obj.Range = Range;
            
            obj.Loc_gt = obj.Range .* rand(obj.Num_nodes, obj.Dim);
            
            if obj.Dim == 2
                
                obj.Loc_gt(1:4, :) = [obj.Range, 0; obj.Range, obj.Range; 0, 0; 0, obj.Range];
            
            elseif obj.Dim == 3
                
                obj.Loc_gt(1:4, :) = [obj.Range, 0, 0; 0, obj.Range, 0; 0, 0, obj.Range; 0, 0, 0];
                
            end
            
            obj.Index_anchor = 1:4;
            obj.Loc_anchor = obj.Loc_gt(1:4, :);
            
            Cor_square = sum(obj.Loc_gt .^ 2, 2);
            M_gt = (-2 .* (obj.Loc_gt * obj.Loc_gt.') + Cor_square) + Cor_square.';
            M_gt(M_gt < 0) = 0;
            M_gt = sqrt(M_gt);
            
            noise = obj.Noise_std .* sqrt(2) .* randn(obj.Num_nodes, obj.Num_nodes);
            noise = ((noise + noise.') ./ 2) .* (1 - eye(obj.Num_nodes));
            obj.M = M_gt + noise;
            
            [iter, time] = obj.Localize();
            obj.Bias = sum(sqrt(sum((obj.Loc_cp - obj.Loc_gt) .^ 2, 2))) ./ obj.Num_nodes;
            
        end
        
        function [iter, time] = Localize(obj)
            
            if obj.Dim == 2
            
                t = tic;
                [Loc, iter] = dhy_MDS_Adam_2D(obj.M, 1e-5);
                obj.Loc_cp = dhy_Ctrans_ICP(Loc, obj.Loc_anchor, obj.Index_anchor);
                time = toc(t);
            
            elseif obj.Dim == 3
                
                t = tic;
                [Loc, iter] = dhy_MDS_Adam_3D(obj.M, 1e-5);
                obj.Loc_cp = dhy_Ctrans_ICP(Loc, obj.Loc_anchor, obj.Index_anchor);
                time = toc(t);
                
            end
            
        end
        
    end
    
end


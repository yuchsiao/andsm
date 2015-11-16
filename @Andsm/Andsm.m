classdef Andsm < handle
    properties
        training_data
        validation_data
        
        model
    end
    properties (Access = private)
        i_best_model
        j_best_model
        
        n
        m

        deg
        kappa
        lambda
        
        prev
        
        err_l2
        err_linf
    end
    methods
        function self = Andsm(training_data, validation_data)
            % Init values

            % Validate training and validation data
            validateData_(training_data, 'training');
            
            if ~isempty(validation_data)
                validateData_(validation_data, 'validation');
            end

            % Store training and validation data
            self.training_data = training_data;
            self.validation_data = validation_data;

            self.m = size(training_data.u{1}, 2);
            self.n = size(training_data.x{1}, 2); 
            
        end
        
        function val = is_solved(self)
            if isempty(self.model)
                val = false;
            else
                val = true;
            end
        end
        
        function prev = get_solver_state(self)
            prev = self.prev;
        end
        function kappa = get_kappa(self)
            kappa = self.kappa;
        end
        function lambda = get_lambda(self)
            lambda = self.lambda;
        end
                
        % Model performance metrics
        val = err(self, errType, stats)
        
        val = err_l2_avg(self)
        val = err_l2_std(self)
        
        val = err_linf_avg(self)
        val = err_linf_std(self)
        
        % Best model (with min avg L2 err)
        [best_model, err_l2_best_model, err_linf_best_model, index_best_model] ...
            = get_best_model(self)
        
        % Model training
        train(self, deg, kappa, lambda, solver_config)
        
        % Export model
        export(self, filename, model_type, model_input, option, model)
    end
    
    methods (Static)
        [tt, uu, xx, yy] = sim(model, time, u, x0, tol)
        [errL2, errLinf] = compute_error(t, x, t_ref, x_ref)
    end
    
end
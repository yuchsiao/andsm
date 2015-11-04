classdef Andsm < handle
    properties
        trainingData
        validationData
        
        model
    end
    properties (Access = private)
        iBestModel
        jBestModel
        
        n
        m

        deg
        kappa
        lambda
        
        prev
        
        errL2
        errLinf
    end
    methods
        function self = Andsm(trainingData, validationData)
            % Init values

            % Validate training and validation data
            validateData_(trainingData, 'training');
            
            if ~isempty(validationData)
                validateData_(validationData, 'validation');
            end

            % Store training and validation data
            self.trainingData = trainingData;
            self.validationData = validationData;

            self.m = size(trainingData.u{1}, 2);
            self.n = size(trainingData.x{1}, 2); 
            
        end
        
        function val = isSolved(self)
            if isempty(self.model)
                val = false;
            else
                val = true;
            end
        end
        
        function prev = getPreviousSolverState(self)
            prev = self.prev;
        end
        function prevKappa = getPreviousKappa(self)
            prevKappa = self.kappa;
        end
        function prevLambda = getPreviousLambda(self)
            prevLambda = self.lambda;
        end
                
        % Model performance metrics
        val = err(self, errType, stats)
        
        val = errL2Avg(self)
        val = errL2Std(self)
        
        val = errLinfAvg(self)
        val = errLinfStd(self)
        
        % Best model (with min avg L2 err)
        [bestModel, errL2BestModel, errLinfBestModel, indexBestModel] ...
            = getBestModel(self)
        
        % Model training
        train(self, deg, kappa, lambda, isIncrementallyStable, solverConfig)
        
        % Export model
        export(self, filename, modelType, modelInput, option, model)
    end
    
    methods (Static)
        [tt, uu, xx, yy] = sim(model, time, u, x0, tol)
        [errL2, errLinf] = computeError(t, x, tRef, xRef)
    end
    
end
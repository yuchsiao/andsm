function export(self, filename, modelType, modelInput, option, model)

if nargin <= 5  % no model
    if ~self.isSolved
        errStruct.message = 'No model and models not trained yet';
        errStruct.identifier = 'Andsi:export:noSolution';
        error(errStruct);
    end
    model = self.model{self.iBestModel, self.jBestModel};
end

if nargin <= 4  % no option
    option = [];
end

[pathstr,filename,~] = fileparts(filename);

switch lower(modelType)
    case {'simulink', 'simscape', 'ssc'}
        % Prepare pinPosition
        if isfield(option, 'pinPosition')
            if lengh(option.pinPosition) ~= model.m
                errStruct.message = 'Length of option.pinPostion must be number of ports';
                errStruct.identifier = 'Andsi:export:pinNumberError';
                error(errStruct);    
            end
        else
            option.pinPosition = repmat('l',1,model.m);
        end
        % Prepare label
        if isfield(option, 'label')
            label = option.label;
        else
            label = filename;
        end

        switch lower(modelInput)
            case {'i', 'current'}
                exportSimscapeI_(model, pathstr, filename, label, option);               
            case {'v', 'voltage'}
                exportSimscapeV_(model, pathstr, filename, label, option);                               
            otherwise
                errStruct.message = 'modelInput is either ''i'' for current (through variable) or ''v'' for voltage (across variable)';
                errStruct.identifier = 'Andsi:export:modelInputError';
                error(errStruct);    
        end
        
    case {'veriloga', 'va'}
        switch lower(modelInput)
            case {'i', 'current'}
                exportVerilogaI_(model, pathstr, filename, option);
            case {'v', 'voltage'}
                
            otherwise
                errStruct.message = 'modelInput is either ''i'' for current (through variable) or ''v'' for voltage (across variable)';
                errStruct.identifier = 'Andsi:export:modelInputError';
                error(errStruct);    
        end
        
    otherwise
        errStruct.message = 'modelType is either ''ssc'' for Simulink or ''va'' for Verilog A';
        errStruct.identifier = 'Andsi:export:modelTypeError';
        error(errStruct);    
end

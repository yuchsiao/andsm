function export(self, filename, model_type, model_input, option, model)

if nargin <= 5  % no model
    if ~self.is_solved
        err_struct.message = 'No model and models not trained yet';
        err_struct.identifier = 'Andsi:export:no_solution';
        error(err_struct);
    end
    model = self.model{self.i_best_model, self.j_best_model};
end

if nargin <= 4  % no option
    option = [];
end

[pathstr,filename,~] = fileparts(filename);

switch lower(model_type)
    case {'simulink', 'simscape', 'ssc'}
        % Prepare pinPosition
        if isfield(option, 'pin_position')
            if length(option.pin_position) ~= model.m
                err_struct.message = 'Length of option.pinPostion must be number of ports';
                err_struct.identifier = 'Andsi:export:pin_number_error';
                error(err_struct);    
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

        switch lower(model_input)
            case {'i', 'current'}
                export_simscape_i_(model, pathstr, filename, label, option);               
            case {'v', 'voltage'}
                export_simscape_v_(model, pathstr, filename, label, option);                               
            otherwise
                err_struct.message = 'model_input is either ''i'' for current (through variable) or ''v'' for voltage (across variable)';
                err_struct.identifier = 'Andsi:export:model_input_error';
                error(err_struct);    
        end
        
    case {'veriloga', 'va'}
        switch lower(model_input)
            case {'i', 'current'}
                export_veriloga_i_(model, pathstr, filename, option);
            case {'v', 'voltage'}
                export_veriloga_v_(model, pathstr, filename, option);
            otherwise
                err_struct.message = 'model_input is either ''i'' for current (through variable) or ''v'' for voltage (across variable)';
                err_struct.identifier = 'Andsi:export:model_input_error';
                error(err_struct);    
        end
        
    otherwise
        err_struct.message = 'model_type is either ''ssc'' for Simulink or ''va'' for Verilog A';
        err_struct.identifier = 'Andsi:export:model_type_error';
        error(err_struct);    
end

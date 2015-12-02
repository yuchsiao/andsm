function [best_model, err_best_model, index_best_model] = get_best_model(self)

if ~self.is_solved
    err_struct.message = 'Models not trained yet';
    err_struct.identifier = 'Andsi:model_best:no_solution';
    error(err_struct);
end

best_model = self.model{self.i_best_model, self.j_best_model};
err = self.err;
err_best_model.l2_avg = err.l2{self.i_best_model, self.j_best_model}.avg;
err_best_model.l2_std = err.l2{self.i_best_model, self.j_best_model}.std;
err_best_model.linf_avg = err.linf{self.i_best_model, self.j_best_model}.avg;
err_best_model.linf_std = err.linf{self.i_best_model, self.j_best_model}.std;
index_best_model = [self.i_best_model, self.j_best_model];


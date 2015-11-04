function [bestModel, errBestModel, indexBestModel] = getBestModel(self)

if ~self.isSolved
    errStruct.message = 'Models not trained yet';
    errStruct.identifier = 'Andsi:modelBest:noSolution';
    error(errStruct);
end

bestModel = self.model{self.iBestModel, self.jBestModel};
err = self.err;
errBestModel.l2Avg = err.L2{self.iBestModel, self.jBestModel}.avg;
errBestModel.l2Std = err.L2{self.iBestModel, self.jBestModel}.std;
errBestModel.linfAvg = err.Linf{self.iBestModel, self.jBestModel}.avg;
errBestModel.linfStd = err.Linf{self.iBestModel, self.jBestModel}.std;
indexBestModel = [self.iBestModel, self.jBestModel];


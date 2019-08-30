function hmmTrain(trainFile, NStates, NSymbols, threshold)
system(['./hmm-1.04/train_hmm ' trainFile ' 123 ' int2str(NStates) ' ' int2str(NSymbols) ' ' num2str(threshold)]);
end
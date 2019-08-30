function temp2 = hmmTest(testFile, model)
system('rm temp*.txt');
system(['./hmm-1.04/test_hmm ' testFile ' ' model '>> temp.txt']);
system('grep "-" temp.txt >> temp2.txt');
load('temp2.txt');
end
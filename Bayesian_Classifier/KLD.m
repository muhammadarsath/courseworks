function divergence = KLD(data, pMean, pCov, qMean, qCov)
p = lkhood(data,pMean,pCov);
q = lkhood(data,qMean,qCov);
divergence = sum(p.*abs(log(p) - log(q)));
end
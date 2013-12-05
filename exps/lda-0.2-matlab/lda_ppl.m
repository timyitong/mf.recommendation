function ppl = lda_ppl(d,beta,gammas)
% ppl = lda_ppl(d,beta,gammas)
% returns the perplexity of d, given LDA model of (beta, gammas).
% $Id: lda_ppl.m,v 1.2 2013/01/16 08:12:08 daichi Exp $
s = 0;
n = length(d);
for i = 1:n
  s = s + sum(d{i}.cnt);
end
ppl = exp (- lda_lik(d,beta,gammas) / s);

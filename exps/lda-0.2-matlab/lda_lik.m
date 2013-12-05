function lik = lda_lik(d,beta,gammas)
% lik = lda_lik(d,beta,gammas)
% returns the likelihood of d, given LDA model of (beta, gammas).
% Fri Oct 22 22:14:48 JST 2004 dmochiha@slt.atr.jp
% $Id: lda_lik.m,v 1.3 2013/01/16 08:12:04 daichi Exp $
egamma = mnormalize(gammas,2);
lik = 0;
n = length(d);
for i = 1:n
  t = d{i};
  lik = lik + t.cnt * log (beta(t.id,:) * egamma(i,:)');
end

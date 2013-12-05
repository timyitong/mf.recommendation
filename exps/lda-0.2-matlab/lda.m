function [alpha,beta] = lda(d,k,emmax,demmax)
% Latent Dirichlet Allocation, standard model.
% Copyright (c) 2004 Daichi Mochihashi, all rights reserved.
% $Id: lda.m,v 1.8 2013/01/16 08:11:40 daichi Exp $
% [alpha,beta] = lda(d,k,[emmax,demmax])
% d      : data of documents
% k      : # of classes to assume
% emmax  : # of maximum VB-EM iteration (default 100)
% demmax : # of maximum VB-EM iteration for a document (default 20)
if nargin < 4
  demmax = 20;
  if nargin < 3
    emmax = 100;
  end
end
n = length(d);
l = features(d);
beta = mnormalize(rand(l,k),1);
alpha = normalize(fliplr(sort(rand(1,k))));
gammas = zeros(n,k);
ppl = 0;
pppl = ppl;
tic;

fprintf(1,'number of documents      = %d\n', n);
fprintf(1,'number of words          = %d\n', l);
fprintf(1,'number of latent classes = %d\n', k);

for j = 1:emmax
  fprintf(1,'iteration %d/%d..\t',j,emmax);
  % vb-estep
  betas = zeros(l,k);
  for i = 1:n
    [gamma,q] = vbem(d{i},beta,alpha,demmax);
    gammas(i,:) = gamma;
    betas = accum_beta(betas,q,d{i});
  end
  % vb-mstep
  alpha = newton_alpha(gammas);
  beta = mnormalize(betas,1);
  % converge?
  ppl = lda_ppl(d,beta,gammas);
  fprintf(1,'PPL = %g\t',ppl);
  if (j > 1) && converged(ppl,pppl,1.0e-4)
    if (j < 5)
      fprintf(1,'\n');
      [alpha,beta] = lda(d,k,emmax,demmax); % try again!
      return;
    end
    fprintf(1,'\nconverged.\n');
    return;
  end
  pppl = ppl;
  % ETA
  elapsed = toc;
  fprintf(1,'ETA:%s (%d sec/step)\r', ...
	  rtime(elapsed * (emmax / j  - 1)),round(elapsed / j));
end
fprintf(1,'\n');

% $Id: lda.m,v 1.8 2013/01/16 08:11:40 daichi Exp $

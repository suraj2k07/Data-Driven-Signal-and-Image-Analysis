clear; clc;
n = 1000;
p = [1e-4, 5e-4, 1e-3, 5e-3, 1e-2, 2e-2, 5e-2, 8e-2, 0.1, 0.2]; 


s = 1./sqrt(p);
E1 = n.*sqrt(p)+n.*(1-(1-p).^s);


np = n .* p;
k  = exp(-np./(np + 1)) ./ (np + 1);

L = log(1 - k);
A = -n .* (1 - p) .* L;

t1 = np;
t2 = (1 + log(A)) ./ L;
E2 = t1 - t2;
figure;
plot(p, E1,'-o', 'DisplayName', 'Method 1 (Optimal s)');
hold on;
plot(p, E2,'-o', 'DisplayName', 'Method 2 (Optimal π, T1)');
xlabel('prevalence rate p ');
ylabel('Expected number of tests');
title('Expected Number of Tests vs prevalence rate p p for n=1000');
legend('Location','best');
grid on;

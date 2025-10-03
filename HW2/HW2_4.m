function cor = cor(im1, im2)
    m1 = mean2(im1);
    m2 = mean2(im2);
    cor = sum(sum((im1 - m1) .* (im2 - m2))); % numerator for correlation coefficient
    den = sqrt(sum(sum((im1 - m1).^2)) * sum(sum((im2 - m2).^2))); % denominator for correlation coefficient
    cor = cor / den;
end
function pmfm = pmfm(im1,im2) % calculating joint pmf matrix 
    z = zeros(26,26); % as bin size is 10 and intensity values will be 0 to 255, so it will be 26 x 26 matrix
    for i = 1:size(im1, 1)
        for j = 1:size(im1, 2)
            if(im1(i,j)~=0 && im2(i,j)~=0) % if atleast 1 is zero then it is from the omitted region
                k = floor(im1(i, j)/10); 
                k1 = floor(im2(i, j)/10);
                z(k+1,k1+1) = z(k+1,k1+1) + 1; 
            end
        end
    end
    su = sum(sum(z)); % total sum of all frequencies
    pmfm = z/su; 
end

function pi1 = pi1(pmf,i) % marginal joint pmf
    pi1  = sum(pmf(i,:));  
end

function pi2 = pi2(pmf,i) % marginal joint pmf
    pi2 = sum(pmf(:, i));
end

function qmi = qmi(im1,im2) % quadratic mutual information
    pmf = pmfm(im1,im2);
    qmi = 0;
    for idxi = 1:size(pmf, 1)
        for idxj = 1:size(pmf, 2)
             qmi = qmi + (pmf(idxi,idxj) - pi1(pmf,idxi)*pi2(pmf,idxj))^2;
        end
    end
end

function mi = mi(im1,im2) % mutual information
    pmf = pmfm(im1,im2);
    mi=0;
    for idxi = 1:size(pmf, 1)
        for idxj = 1:size(pmf, 2)
              if(pmf(idxi,idxj)>0)
              mi = mi + pmf(idxi,idxj) * log(pmf(idxi,idxj)/(pi1(pmf,idxi)*pi2(pmf,idxj)));
              end
        end
    end
end

im1 = double(imread('T1.jpg'));
im11 = double(imread('T2.jpg'));
im1c=im1;
im2=im11;
im3 = im2;
for i = 1:size(im1, 1)
    for j = 1:size(im1, 2)
          if(im1(i,j)==0)
            im1c(i,j)=0.01; % making im1c value to 0.01 because in qmi and mi we are omitting when both 0. 
          end % we are changing the value 0 to 0..01 but it will not effect in qmi and mi as both 0 and 0.01 will fall in the same bin
    end
end

for q = 1:3 % as we have to do same procedure for three values of im2
    if q==2
        im2=255-im1; % in 2nd iteration
        im3=im2;
    elseif q==3 % in 3rd iteration
        im2 = 255 * (im1.^2) / max(im1(:).^2) + 1;
        im3=im2;        
    end

for i = 1:size(im3, 1)
    for j = 1:size(im3, 2) 
          if(im3(i,j)==0)
            im3(i,j)=0.01;  % making im3 value to 0.01 because in qmi and mi we are omitting when both 0. (note: we are doing before shifting)
          end
    end
end

% for tx in range[-10,10]
% Preallocate arrays to store the results
txVals = -10:10;
corrVals = zeros(size(txVals));
qmiVals  = zeros(size(txVals));
miVals   = zeros(size(txVals));

for k = 1:length(txVals)
    tx = txVals(k);
    im2Shifted = zeros(size(im2)); 
    im3Shifted = zeros(size(im3));
    if tx > 0
        % Shift right
        im2Shifted(:, (tx+1):end) = im2(:, 1:(end-tx));
        im3Shifted(:, (tx+1):end) = im3(:, 1:(end-tx));
    elseif tx < 0
        % Shift left
        tx_abs = abs(tx);
        im2Shifted(:, 1:(end-tx_abs)) = im2(:, (tx_abs+1):end);
        im3Shifted(:, 1:(end-tx_abs)) = im3(:, (tx_abs+1):end);
    else
        % No shift
        im2Shifted = im2;
        im3Shifted = im3;
    end

    % after shifting, in the omitted region of im3shifted, the value is 0.

    % Compute metrics
    corrVals(k) = cor(im1, im2Shifted); % we are using img 1 and shifted image of 2 without changing its values
    qmiVals(k) = qmi(im1c, im3Shifted); % for qmi and mi, we are using with modification of 0 with 0.01 of originally presentef values
    miVals(k) = mi(im1c, im3Shifted);
end
% Figure 1: Correlation
figure;
plot(txVals, corrVals, '-o', 'DisplayName', 'Correlation');
xlabel('Translation (txVals)');
ylabel('Correlation');
title('Correlation vs Translation');
grid on; legend('show');

% Figure 2: QMI
figure;
plot(txVals, qmiVals, '-x', 'DisplayName', 'QMI');
xlabel('Translation (txVals)');
ylabel('QMI');
title('QMI vs Translation');
grid on; legend('show');

% Figure 3: Mutual Information
figure;
plot(txVals, miVals, '-s', 'DisplayName', 'Mutual Information');
xlabel('Translation (txVals)');
ylabel('Mutual Information');
title('Mutual Information vs Translation');
grid on; legend('show');
end

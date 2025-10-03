clear; clc;
percent = 0.3;
x = (-3:0.02:3); 
y = 6.5*sin(2.1*x + pi/3);

x_corr = randperm(length(x),round(percent*length(x)));
y_corr = 100 + 20*rand(size(x_corr));
z = y;
z(x_corr) = y_corr;

y_median = [];
for i = 1:length(z)
    y_median(end+1) = median(z(max(1,i-8):min(i+8,length(x))));
 end
 
y_mean = [];
for i = 1:length(z)
   y_mean(end+1) = mean(z(max(1,i-8):min(i+8,length(x))));
 end
y_quartile = [];
for i = 1:length(z)
    y_quartile(end+1) = prctile(z(max(1,i-8):min(i+8,length(x))),25);
end

figure;
plot(x,y,color='b');
hold on;
plot(x,z,color='r');
plot(x,y_mean,'m');
plot(x,y_median,'g'); 
plot(x,y_quartile,'Color',[1 1 1]);
hold off;
 
xlabel('X-axis');
ylabel('Y-label');
title('Filtering a corrupted sine wave');
legend('Original Sine Wave','Corrupted Sine Wave','Movement Average','Movment Median','Movement Quartile');
grid on;
 
saveas(gcf,'filtered_plots.png');

relMedianErr = (y-y_median).^2;
relMedianErr = sum(relMedianErr);

sumsqy = y.^2;
sumsqy = sum(sumsqy);

relMeanErr = sum((y-y_mean).^2);
relQuanErr = sum((y-y_quartile).^2);
relMeanErr = relMeanErr / sumsqy;
relMedianErr = relMedianErr / sumsqy; 
relQuanErr = relQuanErr / sumsqy;

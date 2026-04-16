function Plot_Impedance_Results_Date_paper(features,colors,font_size)

load("Impedance_Interpolated.mat")
load("CapacityPartial.mat")

N = length(Mileage);

%% Plot Statistics
x = t_datetime;

plot_hist_with_gaussian(features.std_valley_val./features.mean_valley_val*100,[0.769 0.855 0.588],'\sigma/\mu HI-c_y [%]',0.0005*100,[0.01*100, 0.035*100],font_size)
plot_mean_std_paper(features.mean_valley_val/1000,features.std_valley_val/1000,'', 'HI-c_y [ k\Omega^{-1}]',x, [0.769 0.855 0.588],font_size)

HI_c = features.std_valley_val ./ features.mean_valley_val * 100;

fprintf('Mean HI-c_y: %.2f%%\n', mean(HI_c))
fprintf('Std  HI-c_y: %.2f%%\n', std(HI_c))

%Depth Voltage


plot_hist_with_gaussian(features.std_peak_v./features.mean_peak_v*100,[0.584 0.710 0.525],'\sigma/\mu HI-c_x [%]',0.00005*100,[3.5e-4*100, 12.5e-4*100],font_size)
plot_mean_std_paper(features.mean_peak_v,features.std_peak_v,'', 'HI-c_x [V]',x, [0.584 0.710 0.525],font_size)

HI_c = features.std_peak_v./features.mean_peak_v*100;

fprintf('Mean HI-c_x: %.2f%%\n', mean(HI_c))
fprintf('Std  HI-c_x: %.2f%%\n', std(HI_c))


end

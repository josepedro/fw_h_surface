% script to calculate directivity using FW-H surface
clear('all');
close all;
load sfwh_surface.mat;
%load matrix_sfwh.mat

% anteparo
%f = 0.0001042;
f = 0.004167;
% duto
f = 0.002593;
theta = (0:10:360)*pi/180;
delta_x = 0.004177e-3;
radius = 15/delta_x;
pressures_theta(1:length(theta)) = 0;
U = 0.15/sqrt(3);
V = 0;

for point = 1:length(theta)
	disp((point/length(theta)*100));
	[x y] = pol2cart(theta(point), radius);
	pesc(1) = x;
	pesc(2) = y;
	pressures_theta(point) = fwh(sfwh_surface,f,U,V,pesc);
	%pressures_theta(point) = fwh(matrix_sfwh,f,U,V,pesc);
end

figure; polar(theta, abs(pressures_theta));
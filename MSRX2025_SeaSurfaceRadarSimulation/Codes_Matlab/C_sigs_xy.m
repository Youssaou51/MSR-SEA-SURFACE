
u_10 = 5
fetch_m = 1e8 

z0 = 3e-3 ;
%
g = 9.81 ; % Acceleration due to gravity (m/s^2) 
x0 = 2.2e4 ; % in m [1997_Elfouhaily_JGR,eq.37]
km = 370 ; % in rad/m [1997_Elfouhaily_JGR,eq.24]
k0_surf = g / u_10^2 ; % in rad/m
xmaj = k0_surf * fetch_m ; % dimensionless [1997_Elfouhaily_JGR,below-eq.4]
omgc = 0.84 * tanh( (xmaj/x0)^0.4 ).^-0.75 ; % [1997_Elfouhaily_JGR,eq.37]
kp = k0_surf * omgc^2 ; % in rad/m [1997_Elfouhaily_JGR,below-eq.3]
cp = sqrt(g*(1+kp^2/km^2)/kp) ; % Phase speed at spectral peek kp
z0 = 3.7e-5 * u_10^2/g * (u_10/cp)^0.9  % Roughness length [1997_Elfouhaily_JGR,eq.66]
%
u_12 = log(12.5/z0)/log(10/z0) * u_10 ; % from [2012_Wang_TGRS,eq36]
sig_sx_CM = sqrt( 3.16e-3 * u_12 )  % see [2013_Pinel_Book,eq1.83]
sig_sy_CM = sqrt( 1.92e-3 * u_12 + 3e-3 )  % see [2013_Pinel_Book,eq1.84]


Nrcs_max_dB = 10*log10( 1/(2*sig_sx_CM*sig_sy_CM) ) 
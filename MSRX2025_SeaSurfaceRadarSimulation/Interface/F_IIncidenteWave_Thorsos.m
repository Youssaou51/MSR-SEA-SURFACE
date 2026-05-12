%
% Incident wave of Thorsos to avoid edge diffraction
%
%   Psi_inc = F_IncidenteWave_Thorsos( theta_inc , g , k0 , X , Z )
%
%   Inputs:
%
%   theta_inc   : Incidence angle [°]
%   g           : Extent (Scalar)
%   k0          : Wave number in medium Omega0 (Scalar)
%   X           : Surface Abscissa (Vector)
%   Z           : Samples of the surface height (Vector)
%
%   Ouputs:
%
%   Psi_inc : Incident field (Vector)
%   p_inc   : Incident power (Scalar)
%
%   Dr. Christophe BOURLIER, 2022
%   Laboratory IETR, Site of Nantes, FRANCE

function [ Psi_inc , p_inc ] = F_IIncidenteWave_Thorsos( theta_inc , g , k0 , X , Z )

thetar_inc = theta_inc * pi / 180 ;
ti = tan(thetar_inc) ;
ci = cos(thetar_inc) ;
si = sin(thetar_inc) ;
eta = 1 ./ ( k0 * g * ci ) ;

kinc_x = k0 * si ;
kinc_z = k0 * ci ;

Ans   = ( X + Z * ti ).^2 / g^2 ;
W_r   = ( 2 * Ans - 1 ) * eta.^2 ;
Psi_inc = exp( 1i * (kinc_x*X - kinc_z *Z) .* (1+W_r) - Ans ) ;

% Incidenct power
p_inc = 0.5 * ci * g * sqrt(pi/2) * ( 1 - (1+2*ti^2)./(2*k0.^2*g^2*ci^2) ) ;
%
% Function computing the far field
%
% function Psi = F_FarField( ...
%   X , Z , Dx , DerZ , V , k , Psi , D_Psi , Thetar_sca )
%
%   Inputs:
%
%   X       : Surface abscissa (Vector)
%   Z       : Surface elevation (Vector)
%   Dx      : Sampling step (Vector)
%   DerZ    : First derivative of Z over X (Vector)
%   V       : Sense of the surface normal (+1 or -1) (Vector)
%   k       : Wavenumber in medium (Scalar)
%   Psi     : Field on the surface (Vector)
%   D_Psi   : Normal derivative of Psi (Vector)
%   Thetar_sca : Observation angle (Vector)
%
%   Output:
%
%   Psi     : Far field
%
%   Dr. Christophe BOURLIER, 2022
%   Laboratory IETR, Site of Nantes, FRANCE

function Psi_sca = F_IFarField( ...
    X , Z , Dx , DerZ , V , k , Psi , D_Psi , Thetar_sca )

Psi_sca = zeros(size(length(Thetar_sca))) ;
for i_ = 1 : 1 : length(Thetar_sca) % Huygens principle
    
    Ans_=-1i*k*(DerZ*sin(Thetar_sca(i_))-cos(Thetar_sca(i_))).*Psi ;
    Ans_ = Ans_ + V.*sqrt(1+DerZ.^2).*D_Psi ;
    Ans_ = Ans_ .* exp(-1i*k*(sin(Thetar_sca(i_))*X+cos(Thetar_sca(i_))*Z)) ;
    Psi_sca(i_) = sum(Dx.*Ans_) ;
    
end

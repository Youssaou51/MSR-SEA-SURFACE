%
% Function computing the elements of the impedance matrix
%
% function ZZ = F_ImpedanceMatrices( ...
%       X , Z , Dx , DerZ , Der2Z , V , k0 , k1 , Case )
%
%   Inputs:
%
%   X       : Surface abscissa (Vector)
%   Z       : Surface elevation (Vector)
%   Dx      : Sampling step (Vector)
%   DerZ    : First derivative of Z over X (Vector)
%   Der2Z   : Second derivative of Z over X (Vector)
%   V       : Sense of the surface normal (+1 or -1) (Vector)
%   k0      : Wavenumber in medium Omega0 (Scalar)
%   k1      : Wavenumber in medium Omega1 (Scalar)
%   Polar   : TE (Dirichlet) or TM (Neumann)
%
%   Output:
%
%   ZZ      : Impedance matrix (Matrix)
%
%   Dr. Christophe BOURLIER, 2022
%   Laboratory IETR, Site of Nantes, FRANCE

function ZZ = F_IImpedanceMatrices( X , Z , Dx , DerZ , Der2Z , V , k0 , Polar )

if strcmp(Polar,'TE') % Dirichlet case
    
    Ds = abs(Dx) .* sqrt(1+DerZ.^2) ;
    ZZ = F_ImpedanceMatrice_Dir( X , Z , Ds , k0 ) ; % Else matrix B
      
elseif strcmp(Polar,'TM') % Neumann case
        
    ZZ = F_ImpedanceMatrice_Neu( X , Z , Dx , V , DerZ , Der2Z , k0 , +1 ) ; % Else matrix A

else
    
    fpritnf('< The variable %s does not match with TE or TM >',Polar)
    disp('< PAUSE >')
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dirichlet boundary conditions %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ZZ = F_ImpedanceMatrice_Dir( X , Z , Ds , k )

n = length(X) ;
ZZ = zeros(n,n) ;
Cste = 1i * Ds / 4 ;
euler = 1.78107 ;   
Diag = ones(1,n) + (1i * 2 / pi) * log ( euler * k * Ds / ( 4 * exp(1) ) ) ; 
        
for m = 1 : 1 : n
    
    Xn = X(m+1:n) ; xm = X(m) ;
    Zn = Z(m+1:n) ; zm = Z(m) ;
    Arg = k*sqrt( (Xn-xm).^2 + (Zn-zm).^2 ) ;
    Ho1 = besselh(0,1,Arg) ;
    % n changes (OBSERVATION)
    ZZ(m,m+1:n) = Cste(m+1:n) .* Ho1 ;
    % m changes (SOURCE)
    ZZ(m+1:n,m) = Cste(m) .* Ho1 ;
    ZZ(m,m) = Cste(m) * Diag(m) ; % Diagonal element
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Neumann boundary conditions %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ZZ = F_ImpedanceMatrice_Neu( X , Z , Dx , V , DerZ , Der2Z , k , sgn_n )

n = length(X) ;
ZZ = zeros(n,n) ;
Diag = 0.5*sgn_n - V.*abs(Dx).*Der2Z./(1+DerZ.^2)/(4*pi) ;

for m = 1 : 1 : n
    
    Xn = X(1:n) ; xm = X(m) ;
    Zn = Z(1:n) ; zm = Z(m) ;
    Rnm = sqrt( (Xn-xm).^2 + (Zn-zm).^2 ) ;
    Ans_ = -(1i*k/4) * V .* abs(Dx) .* ( DerZ.*(Xn-xm) - (Zn-zm) ) ;
    ZZ(m,:) = Ans_ .* besselh(1,1,k*Rnm) ./ Rnm ;
    ZZ(m,m) = Diag(m) ; % Diagonal element

end
        
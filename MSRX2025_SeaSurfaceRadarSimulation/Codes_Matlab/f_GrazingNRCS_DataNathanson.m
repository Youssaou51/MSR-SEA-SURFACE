function [Nrcs_Mdl_dB_VV, Nrcs_Mdl_dB_HH] = f_GrazingNRCS_DataNathanson (Chi_d, lambda_m, SeaState, ph__d, polar)

%--------------------------------------------------------------------------
% FUNCTION : f_GrazingNRCS_DataNathanson
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient) of a (2D) sea surface for 3D problems, 
% in VV and HH polarizations, from data of Nathanson, "with some
% extrapolation and interpolation between data points" [Nathanson_1991_MGH]
% (see also [Spiga_2008_These,Tab.4.1-3])
%--------------------------------------------------------------------------
% Input variables:
% Chi_d     : Grazing angle -> relative to horizon (deg.) [Vector/Matrix]
% lambda_m  : Radar wavelength (m) [scalar]
% SeaState  : Sea state (Beaufort scale] (-) [Vector/Matrix]
% ph__d     : Relative Azimuth angle between LOS and wind direction (deg.) [scalar]
% polar     : Polarization ('H' or 'V') [string of length 1]
%--------------------------------------------------------------------------
% Output variables:
% Nrcs_Mdl_dB_VV : Grazing NRCS under considered model in VV pol. [Vector/Matrix - dB scale]
% Nrcs_Mdl_dB_HH : Grazing NRCS under considered model in HH pol. [Vector/Matrix - dB scale]
%--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
% Nathanson, Reilly and Cohen, "Radar Design Principles - Signal Processing
% and the Environment", Second Edition, 1991 (pp. 275-278)
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL, 12/2015
%--------------------------------------------------------------------------

SeaState_Data = (0 : 1 : 6).' ;
FgHz_Dat = [ 0.50 1.25 3.00 5.60 9.30 17.0 35.0 ] ; % last value: 35/94
Chi_d_Data = [ 0.1 0.3 1.0 3.0 10 30 60 ] ;
%
NRCs_data = zeros([2*length(SeaState_Data) length(FgHz_Dat) length(Chi_d_Data)]) ;
ERRr_data = zeros([2*length(SeaState_Data) length(FgHz_Dat) length(Chi_d_Data)]) ;

% Data for grazing angle of 0.1° [Nathanson_1991_MGH,Tab.7.2]:
NRCs_data(:,:,1) = [ NaN NaN NaN NaN NaN NaN NaN ;
                     NaN NaN -90 -87 NaN NaN NaN ;
                     NaN NaN -80 -72 -65 NaN NaN ; 
                     NaN NaN -80 -75 -71 NaN NaN ; 
                     -90 -87 -75 -67 -56 NaN NaN ; 
                     -95 -90 -75 -67 -59 -48 NaN ; 
                     -88 -82 -75 -60 -51 NaN -47 ; 
                     -90 -82 -68 -69 -53 NaN NaN ; 
                     -85 -78 -67 -58 -48 NaN -45 ; 
                     NaN -74 -63 -60 -48 NaN NaN ; 
                     -80 -70 -63 -55 -44 NaN -42 ; 
                     NaN -70 -63 -58 -42 NaN NaN ; 
                     NaN NaN -56 NaN NaN NaN NaN ; 
                     NaN NaN NaN NaN NaN NaN NaN ] ;
ERRr_data(:,:,1) = [ NaN NaN NaN NaN NaN NaN NaN ;
                     NaN NaN   5   5 NaN NaN NaN ;
                     NaN NaN   5   5   5 NaN NaN ; 
                     NaN NaN NaN NaN   5 NaN NaN ; 
                              8   5   5 NaN NaN NaN NaN ; 
                       8   5   5   5   5   5 NaN ; 
                       8   5   5   5 NaN NaN   5 ; 
                       8   5   5   5   5 NaN NaN ; 
                       8   5   5   5 NaN NaN   5 ; 
                     NaN   5   5 NaN NaN NaN NaN ; 
                       8   5   5   5 NaN NaN   5 ; 
                     NaN   8   5   5   5 NaN NaN ; 
                     NaN NaN NaN NaN NaN NaN NaN ; 
                     NaN NaN NaN NaN NaN NaN NaN ] ;

% Data for grazing angle of 0.3° [Nathanson_1991_MGH,Tab.7.3]:
NRCs_data(:,:,2) = [ NaN -83 NaN NaN NaN -63 -55 ;
                     NaN NaN -83 -79 -74 NaN NaN ;
                     NaN -78 -64 -60 -58 -54 -46 ; 
                     NaN NaN -74 -68 -66 -58 NaN ; 
                     -80 -73 -62 -55 -52 -52 -43 ; 
                     -78 NaN -66 -60 -56 -53 NaN ; 
                     -78 -70 -58 -50 -45 -47 -40 ; 
                     NaN -68 -60 -50 -46 -42 NaN ; 
                     -75 -65 -57 NaN -43 -44 -38 ; 
                     NaN NaN -55 NaN -42 -39 NaN ; 
                     -73 -64 -52 NaN -39 -39 -35 ; 
                     NaN -64 -52 -44 -39 -38 NaN ; 
                     NaN NaN NaN NaN -34 -37 -31 ; 
                     NaN NaN -46 NaN -34 -37 NaN ] ;
ERRr_data(:,:,2) = [ NaN   8 NaN NaN NaN   5   8 ;
                     NaN NaN   5 NaN   5 NaN NaN ;
                     NaN   5   5 NaN NaN   5   8 ; 
                     NaN NaN NaN NaN   5 NaN NaN ; 
                       8   5   5 NaN NaN   5   8 ; 
                       5 NaN   5 NaN   5   5 NaN ; 
                       8   5   5   5 NaN   5   5 ; 
                     NaN   5   5 NaN NaN   5 NaN ; 
                       8 NaN   5 NaN NaN   5 NaN ; 
                     NaN NaN   5 NaN NaN   5 NaN ; 
                       8   5   5 NaN NaN NaN   5 ; 
                     NaN   5   5   5 NaN   5 NaN ; 
                     NaN NaN NaN NaN NaN   5   5 ; 
                     NaN NaN   5 NaN NaN   5 NaN ] ;

% Data for grazing angle of 1.0° [Nathanson_1991_MGH,Tab.7.4]:
NRCs_data(:,:,3) = [ NaN -68 NaN NaN -60 -60 -60 ;
                     -86 -80 -75 -70 -60 -60 -60 ;
                     -70 -65 -56 -53 -50 -50 -48 ; 
                     -84 -73 -66 -56 -51 -48 -48 ; 
                     -63 -58 -53 -47 -44 -42 -40 ; 
                     -82 -65 -55 -48 -46 -41 -38 ; 
                     -58 -54 -48 -43 -39 -37 -34 ; 
                     -73 -60 -48 -43 -40 -37 -36 ; 
                     -58 -45 -42 -39 -37 -35 -32 ; 
                     -63 -56 -45 -39 -36 -34 -34 ; 
                     NaN -43 -38 -35 -33 -34 -31 ; 
                     -60 -50 -42 -36 -34 -34 NaN ; 
                     NaN NaN -33 NaN -31 -32 NaN ; 
                     NaN NaN -41 NaN -32 -32 NaN ] ;
ERRr_data(:,:,3) = [ NaN   5 NaN NaN   5   5   5 ;
                       5   5   5   5   5   5   5 ;
                       5   5 NaN NaN NaN   5   5 ; 
                       5   5 NaN NaN NaN   5   5 ; 
                       5   5 NaN NaN NaN NaN   5 ; 
                       5   5 NaN NaN NaN NaN   5 ; 
                       5   5 NaN NaN NaN NaN NaN ; 
                       5   5 NaN NaN NaN NaN NaN ; 
                       5 NaN NaN NaN NaN NaN NaN ; 
                       5   5 NaN NaN NaN NaN   5 ; 
                     NaN NaN NaN NaN NaN NaN NaN ; 
                       5   5 NaN NaN NaN NaN NaN ; 
                     NaN NaN NaN NaN   5 NaN NaN ; 
                     NaN NaN NaN NaN   5 NaN NaN ] ;

% Data for grazing angle of 3.0° [Nathanson_1991_MGH,Tab.7.5]:
NRCs_data(:,:,4) = [ NaN NaN NaN -60 NaN -50 -48 ; % 5th value: < -56
                     -75 -72 -68 -63 NaN NaN -53 ; % 5th value: < -58
                     -60 -53 -52 -49 -45 -41 -41 ; 
                     -70 -62 -59 -54 -50 -45 -43 ; 
                     -53 -50 -49 -45 -41 -39 -37 ; 
                     -66 -59 -53 -48 -43 -38 -40 ; 
                     -43 -43 -43 -40 -38 -36 -34 ; 
                     -61 -55 -46 -42 -39 -35 -37 ; 
                     -38 -38 -38 -36 -35 -33 -31 ; 
                     -54 -48 -41 -38 -35 -32 -32 ; 
                     -40 -38 -35 -35 -33 -31 -30 ; 
                     -53 -46 -40 -36 -33 -30 NaN ; 
                     NaN NaN NaN NaN -28 -28 NaN ; 
                     NaN NaN -37 NaN -30 -28 NaN ] ;
ERRr_data(:,:,4) = [ NaN NaN NaN   4   4   4   4 ; % 5th value: < -56
                       4   4   4   4   4 NaN NaN ; % 5th value: < -58
                       4   4 NaN NaN NaN   4 NaN ; 
                       4   4 NaN NaN NaN   4   4 ; 
                     NaN NaN NaN NaN NaN NaN NaN ; 
                       4 NaN NaN NaN NaN NaN NaN ; 
                       4   4 NaN NaN NaN NaN NaN ; 
                       4   4 NaN NaN NaN NaN NaN ; 
                       4 NaN NaN NaN NaN NaN NaN ; 
                       4   4 NaN NaN NaN   4 NaN ; 
                       4 NaN NaN NaN NaN   4   4 ; 
                     NaN NaN NaN NaN NaN   4 NaN ; 
                     NaN NaN NaN NaN NaN NaN NaN ; 
                     NaN NaN NaN NaN NaN NaN NaN ] ;

% Data for grazing angle of 10° [Nathanson_1991_MGH,Tab.7.6]:
NRCs_data(:,:,5) = [ NaN -45 NaN -44 NaN NaN -44 ; % 5th value: < -47; 6th value: < -45
                     NaN -60 NaN NaN NaN NaN NaN ; % 5th value: < -56
                     -38 -39 -40 -41 -42 -40 -38 ; 
                     NaN -56 NaN -53 -51 NaN NaN ; 
                     -35 -37 -38 -39 -36 -34 -33 ; 
                     -54 -53 -51 -48 -43 -37 -36 ; 
                     -34 -34 -34 -34 -32 -31 -31 ; 
                     -50 -48 -46 -40 -37 -32 -31 ; 
                     -32 -31 -31 -32 -29 -28 -29 ; 
                     -48 -45 -40 -36 -34 -29 -29 ; 
                     -30 -30 -28 -28 -25 -23 -26 ; 
                     -46 -43 -38 -36 -30 -26 -27 ; 
                     -30 -29 -28 -27 -22 -18 NaN ; 
                     -44 -40 -37 -35 -27 -24 NaN ] ;
ERRr_data(:,:,5) = [ NaN   4 NaN   4   4   4   4 ; % 5th value: < -47; 6th value: < -45
                     NaN   4 NaN NaN   4 NaN NaN ; % 5th value: < -56
                     NaN NaN NaN NaN NaN NaN NaN ; 
                     NaN   4 NaN NaN NaN NaN NaN ; 
                       4 NaN NaN NaN NaN NaN NaN ; 
                       4 NaN NaN NaN NaN NaN   4 ; 
                       4 NaN NaN NaN NaN NaN NaN ; 
                     NaN NaN NaN NaN NaN NaN NaN ; 
                       4 NaN   4 NaN NaN NaN NaN ; 
                       4 NaN NaN NaN NaN NaN NaN ; 
                     NaN NaN NaN NaN NaN NaN   4 ; 
                     NaN NaN NaN NaN NaN NaN   4 ; 
                       4 NaN NaN   4   4   4 NaN ; 
                       4   4 NaN   4   4   4 NaN ] ;

% Data for grazing angle of 30° [Nathanson_1991_MGH,Tab.7.7]:
NRCs_data(:,:,6) = [ NaN -42 -42 -42 -37 -33 NaN ; 
                     NaN -50 -50 -50 -48 -45 NaN ; 
                     -38 -38 -40 -42 -36 -31 -35 ; 
                     NaN -46 NaN -48 -44 -38 NaN ; 
                     -30 -31 -32 -34 -32 -26 -30 ; 
                     -42 -41 -40 -42 -38 -35 -35 ; 
                     -28 -30 -29 -28 -26 -23 -23 ; 
                     -40 -39 -38 -37 -34 -28 -29 ; 
                     -28 -28 -27 -25 -24 -22 -22 ; 
                     -38 -37 -37 -35 -29 -21 -21 ; 
                     -28 -24 -23 -22 -22 -18 -20 ; 
                     -35 -34 -32 -30 -26 -18 -20 ; 
                     -25 -23 -22 -21 -17 -15 NaN ; 
                     -33 -32 -30 -29 -21 -16 NaN ] ;
ERRr_data(:,:,6) = [ NaN   5   5   5   5   5 NaN ; 
                     NaN   5   5   5   5   5 NaN ; 
                       5   5 NaN NaN NaN   5   5 ; 
                     NaN   5 NaN NaN   5   5 NaN ; 
                     NaN NaN   5 NaN NaN   5 NaN ; 
                     NaN NaN NaN NaN   5   5   5 ; 
                     NaN NaN NaN NaN NaN NaN   5 ; 
                       5 NaN NaN NaN NaN NaN   5 ; 
                     NaN NaN NaN NaN NaN NaN NaN ; 
                       5 NaN NaN NaN NaN NaN NaN ; 
                     NaN   5 NaN NaN NaN NaN   5 ; 
                     NaN   5 NaN NaN NaN NaN   5 ; 
                       5   5   5   5 NaN NaN NaN ; 
                       5   5   5   5   5 NaN NaN ] ;

% Data for grazing angle of 60° [Nathanson_1991_MGH,Tab.7.8]:
NRCs_data(:,:,7) = [ -32 -33 -34 -26 -23 -22 NaN ; 
                     -32 -32 -32 -27 -25 -22 -26 ; 
                     -23 -22 -24 -24 -24 -20 -24 ; 
                     -22 -24 -25 -26 -24 -20 NaN ; 
                     -20 -21 -21 -23 -18 -18 -19 ; 
                     -22 -21 -21 -22 -23 -18 NaN ; 
                     -18 -18 -19 -18 -16 -14 -14 ; 
                     -21 -20 -20 -20 -21 -16 -16 ; 
                     -14 -15 -15 -15 -14 -11 -10 ; 
                     -21 -18 -17 -16 -15 -12 -12 ; 
                     -18 -15 -15 -15 -13 -11 -04 ; 
                     -21 -18 -17 -17 -14 -10 NaN ; 
                     -18 -17 -15 -14 -11 -10 NaN ; 
                     -20 -19 -17 -16 -12 -10 NaN ] ;
ERRr_data(:,:,7) = [ NaN NaN NaN   3 NaN   3 NaN ; 
                     NaN NaN NaN   3   3   3   3 ; 
                       3 NaN NaN NaN NaN   3   3 ; 
                     NaN NaN NaN NaN NaN NaN NaN ; 
                       3 NaN NaN NaN NaN   3   3 ; 
                     NaN NaN NaN NaN NaN   3 NaN ; 
                       3   3 NaN   3   3 NaN   3 ; 
                     NaN NaN NaN NaN NaN   3   3 ; 
                       3   3   3   3   3 NaN NaN ; 
                       3   3   3   3   3   3   3 ; 
                       3   3 NaN NaN   3   3 NaN ; 
                       3   3 NaN NaN NaN   3 NaN ; 
                       3   3   3   3   3   3 NaN ; 
                       3   3   3   3   3 NaN NaN ] ;
'A FINIR : DECIDER SI JE METS CA SOUS FORME DE FONCTION OU QUOI, ET SI OUI, SOUS QUELLE FORME'

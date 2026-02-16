SeaRadarSimulator - Documentation


Introduction

Welcome to the first version of SeaRadarSimulator, a graphic interface (MISTLETOE) developed in MATLAB to simulate the efficient section radar normalised (NRCS) in monostatic shape on a maritime surface. This interface allows to explore different empirical, semi-empirical and experimental models to calculate the NRCS as a function of parameters such as frequency, angle of incidence, wind speed, and polarization.



Interface

The interface is designed with an intuitive layout:

- Top banner: Displays title and logo ICAM
- Left section: Contains input parameters (frequency band, frequency, angle of incidence, polarization, wind speed, relative wind angle, and selected model) with validation notes for each model.
- Right section: Displays curve NRCS and calculated results, including a warning label to signal the conversion of speed to sea for some models
- Buttons: Allow you to calculate, save, or load configurations.
NB: For the moment only the button "Calculate" is active, the others are for the moment only placeholders.



Prerequested

To use this interface, you must have:

- MATLAB: A recent version (R2016a or higher recommended, designed and tested with R2025a).
- GUI Layout Toolbox: This toolbox is necessary to manage the layout of the interface. It is not included by default with MATLAB and must be downloaded separately.

--Where to download: You can get the Layout Toolbox GUI via the link https://fr.mathworks.com/matlabcentral/fileexchange/47982-gui-layout-toolbox or via the MATLAB add-ons manager (search for "GUI Layout Toolbox" in Add-Ons Explorer).
--Installation: After downloading, unzip the archive and add the path to the MATLAB (for example, with addpath ('path/to/GUI Layout Toolbox').



Contents of the dossier

- README
- SeaRadarSimulator.m: The main script containing interface and logic of calculation.
- Model functions: The folder includes the function files needed to calculate the NRCS according to the models implemented (e.g. f_Nrcs_3dMono_EmpExpSea_Cband_Cmod5.m, f_Nrcs_3dMonoGrazing_NRL_2012.m, etc.). Make sure these files are in the same folder or in the MATLAB path for the interface to work properly.
- logo_icam.png: Image of the logo ICAM for the banner.
- f_Sea_WindSpeedHeightConversion used for conversion from u10 to u19



Use

- Run the interface: Run the script SeaRadarSimulator_v1.m in MATLAB.

- Configure the parameters:

-- Select the frequency band and adjust the frequency if necessary.
-- Define the angle of incidence, polarization, wind speed, and relative wind angle.
- Choose a model among available options (NRL, TSC, be lying, HYBRID, SITTROP, RRE, Quilfen, CMOD2-I3, CMOD5, Isoguchi, XMOD1R, XMOD2N, Meissner, Wentz84, Wentz99, Masuko_X, Masuko_Ka).
NB: Once the model has selected the ranges of possible values for the parameters are displayed, it is important to check if the data entered match before continuing to avoid errors later.


- Calculate: Click the "Calculate" button to display the curve NRCS and the result for the specified angle of incidence.
- Save/Load: These two buttons are currently inactive and just present for guidance.
- Warnings: Warning messages (in orange) appear if the parameters are outside the valid ranges or if approximations are made.



Important notes

- Dependencies: Check that the Layout Toolbox GUI is correctly installed and that its path is added (see Prerequisites).
- Models: The functions of the models must be accessible in the MATLAB path. If an error occurs, make sure that all the function files are present.
- Future improvements: This version is a first iteration. Additional features will be added in future versions.



Contributions

This interface is currently being developed by Rosilia MODJO (rosilia.modjo@2027.icam.fr) under the supervision of M. Nicolas PINEL (nicolas.pinel@icam.fr)

If you would like to contribute or report any problems, please contact this address nicolas.pinel@icam.fr. Any suggestion is welcome to improve this tool!
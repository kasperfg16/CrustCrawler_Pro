%Verification code for Forward Kinematics for Crustcrawler
%Group 364 3. semester 2020
%NOTE: That to use this code the Robotis Toolbox for MATLAB by -
%Peter Corke must be added to the directory folder of MATLAB

clear all;

l_1 = 173.6000;   %mm
l_2 = 219.80;   %mm
l_3 = 277.8;    %mm

%Using Robotic Toolbox

L(1) = Link('alpha', 0      , 'a', 0        , 'd'   , l_1               , 'modified');
L(2) = Link('alpha', pi/2   , 'a', 0        , 'd'   , 0     , 'offset', pi/2, 'modified');
L(3) = Link('alpha', 0      , 'a', l_2      , 'd'   , 0                     , 'modified');
L(4) = Link('alpha', 0      , 'a', l_3      , 'd'   , 0                     , 'modified');

r=SerialLink(L ,'name', 'Crustcrawler')
r.teach()
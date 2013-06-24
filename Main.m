clear;clc;
% make sure we add the correct folders even if this file is
% not called from the current folder
fileName = mfilename();
filePath = mfilename('fullpath');
filePath = filePath(1:end-size(fileName, 2));

% Add folders to current path
path(genpath([filePath 'Files']), path);

fprintf('Face Morphing: Starting DEMO...\n');

% Open main GUI
FaceMorphingDemo;

fprintf('Face Morphing: Ready.\n\n');

% clear variables
clearvars fileName filePath
function [s_bin] = binarisation(signal,seuil)

%On récupére les zones où le signal est au dessus d'un seuil

s_bin = signal>seuil;


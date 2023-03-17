function [coor] = tirage_coordo()

%On délimite nous même un cube qui représentera la zone possible d'où
%peuvent être émis les signaux

coor = randi([1,1000],1,3);
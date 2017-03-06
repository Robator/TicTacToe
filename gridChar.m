function c = gridChar(i) 
%transforms number to X or O
    switch i 
        case 1 
            c='X';
        case 0
            c=' ';
        case 2
            c='O';
    end
end
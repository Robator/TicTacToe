function [] = tictactoe2()
    tempboard = zeros(64);
    board = tempboard(1,:)
    disp(board)
    player=1;
    for turn=1:64
        if win(board) == 0
            if rem(turn+player, 2) == 0
                board = computerMove(board);
            else 
                draw(board);
                board = playerMove(board);
            end
        end
    end
    switch win(board) 
        case 0
            disp('A draw. How droll.\n');
        case 1
            draw(board);
            disp('You lose.\n');
        case -1
            disp('You win. Inconceivable!\n');
    end
end


function c = gridChar(i) 
    switch i 
        case -1 
            c='X';
        case 0
            c=' ';
        case 1
            c='O';
    end
end

function [win] = win(board) 
    wins1 = [1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16;
        1 5 9 13; 2 6 10 14; 3 7 11 15; 4 8 12 16;
        1 6 11 16; 4 7 10 13];
    wins2 = wins1+16;
    wins3 = wins2+16;
    wins4 = wins3+16;%40
    wins5 = [1 17 33 49; 2 18 34 50; 3 19 35 51; 4 20 36 52; 1 18 35 52; 4 19 34 49];
    wins6 = wins5+4;
    wins7 = wins6+4;
    wins8 = wins7+4;%24
    wins9 = [1 22 43 64; 4 23 42 61; 13 26 39 52; 16 27 38 49];
    wins = cat(1, wins1, wins2, wins3, wins4, wins5, wins6, wins7, wins8, wins9);
    win =0;
    
    for i=1:68
        if board(wins(i,1)) ~= 0 && ...
           board(wins(i,1)) == board(wins(i,2)) && ... 
           board(wins(i,1)) == board(wins(i,3)) && ...
           board(wins(i,1)) == board(wins(i,4))
            win = board(wins(i,1));
            break;
        end
    end
end

function [] = draw( b)
    fprintf(' %c | %c | %c\n',gridChar(b(1)),gridChar(b(2)),gridChar(b(3)));
    disp('---+---+---\n');
    fprintf(' %c | %c | %c\n',gridChar(b(4)),gridChar(b(5)),gridChar(b(6)));
    disp('---+---+---\n');
    fprintf(' %c | %c | %c\n',gridChar(b(7)),gridChar(b(8)),gridChar(b(9)));
    disp('\n')
end

function [a] = minimax(board, player) 
     winner = win(board);
    if(winner ~= 0) 
        a = winner*player;
        return;
    end

    move = -1;
    score = -2;
    for i=1:64
        if(board(i) == 0)
            board(i) = player;
            thisScore = -minimax(board, player*(-1));
            if(thisScore > score) 
                score = thisScore;
                move = i;
            end
            board(i) = 0;
        end
    end
    if(move == -1) 
        a = 0;
        return;
    end
    a = score;
end

function board = computerMove(board) 
    move = -1;
    score = -2;
    for i=1:9
        if(board(i) == 0) 
            board(i) = 1;
            disp('!')
            tempScore = -minimax(board, -1);
            board(i) = 0;
            if(tempScore > score) 
                score = tempScore;
                move = i;
            end
        end
    end
    board(move) = 1;
end

function board = playerMove(board) 
    move = 1;
    while (move >= 9 || move < 0 || board(move) ~= 0)
        move = input('\nInput move ([0..8]): ');
    end
    board(move) = -1;
end


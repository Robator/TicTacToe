% function [] = tictactoe2()
%     is_x = 1; % keeps track of the current player
%     global state
%     state = zeros(4,4,4)
%     minimax
%          
% end
% function [] = minimax(level,player)
%     global state
%     for i=1:4
%         for j=1:4
%             for k=1:4
%                 if state(i,j,1)==0

function tictactoe2()
global summa
summa = 0
    board = [0,0,0,0,0,0,0,0,0];
    player=1;
    for turn=1:9
        if win(board) == 0
            if rem(turn+player, 2) == 0
                board = computerMove(board);
            else 
                draw(board);
                board = playerMove(board);
            end
        end
    end
    write_winner(board)
end

function write_winner(board)
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

function win = win(board) 
    wins = [1 2 3; 4 5 6; 7 8 9; 1 4 7; 2 5 8; 3 6 9; 1 5 9; 3 5 7];
    for i=1:8
        if board(wins(i,1)) ~= 0 && ...
           board(wins(i,1)) == board(wins(i,2)) && ... 
           board(wins(i,1)) == board(wins(i,3))
            win = board(wins(i,3));
            return
        end
    end
    win = 0;
end

function draw( b)
        fprintf(' %c | %c | %c\n',gridChar(b(1)),gridChar(b(2)),gridChar(b(3)));
        disp('---+---+---\n');
        fprintf(' %c | %c | %c\n',gridChar(b(4)),gridChar(b(5)),gridChar(b(6)));
        disp('---+---+---\n');
        fprintf(' %c | %c | %c\n',gridChar(b(7)),gridChar(b(8)),gridChar(b(9)));
        disp('\n')
end

function a = minimax(board, player) 
global summa
     winner = win(board);
    if(winner ~= 0) 
        a = winner*player;
    end

    move = -1;
    score = -2;
    for i=1:9
        summa=summa+i;
        
            
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
    end
    a = score;
end

function board = computerMove(board) 
    move = 1;
    score = -2;
    for i=1:9
        if(board(i) == 0) 
            board(i) = 1;
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
    move = -1;
    global summa
    disp(summa)
    while move >= 9 || move < 0 || board(move) ~= 0
        move = input('\nInput move ([1..8]): ')
    end
    board(move) = -1;
end


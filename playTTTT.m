function move = playTTTT(board, player)
%Tictactoe 3D game is based on minimax algorithm with some improvements

	%transform matrix to an array - easier to implement
	board = arrToBoard(board);
	move = -1;%init
    score = -2;
	depth = 2;
	
	%if empty - give random move
	if (sum(board)==0)
	   move = round(rand*63)+1;
	   move = mtoV(move);
	   return;
	end

	%players encoded for minimax
    if player==1 
        plr = -1;
    elseif player==2
        plr = 1;
	else
		disp('Wrong player');
		return		
	end
	
	%make minimax for all cells
    for i=1:64
		%for empty cells try
        if(board(i) == 0) 
			%try the first empty cell
            board(i) = player;
            tempScore = -minimax(board, depth, plr);
            board(i) = 0;%reset cell
            if(tempScore > score) 
                score = tempScore;
                move = i;
			end
			if score == 1 %cant play better
				break
            end
			
		end
		
    end
    if (score == 0) 
        while(true)
        move = round(63*rand)+1;
        if (board(move)==0)
            move = mtoV(move);
           return; 
        end
            
        end
    else
    move = mtoV(move);
    end
	%make a move that has the maximum score
    %board(move) = plr;
end

function write_winner(board)
switch win(board) 
        case 0
			draw(board);
            disp('A draw. How droll.\n');
			
        case 1
            draw(board);
            disp('X win.\n');
        case 2
			draw(board);
            disp('O win. Inconceivable!\n');
    end
end

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

function win = win(board) %win combinations
	%determines if a player has won, returns 0 otherwise.
	
     wins1 = [1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16;
        1 5 9 13; 2 6 10 14; 3 7 11 15; 4 8 12 16;
        1 6 11 16; 4 7 10 13];%on plane 1
    wins2 = wins1+16;
    wins3 = wins2+16;%on plane 3
    wins4 = wins3+16;%40 on plane 4
    wins5 = [1 17 33 49; 2 18 34 50; 3 19 35 51; 4 20 36 52; 1 18 35 52; 4 19 34 49];%vertical plane 1
    wins6 = wins5+4;
    wins7 = wins6+4;%vertical plane 3
    wins8 = wins7+4;%24
    wins9 = [1 22 43 64; 4 23 42 61; 13 26 39 52; 16 27 38 49];%diagonals
	wins = cat(1, wins1, wins2, wins3, wins4, wins5, wins6, wins7, wins8, wins9);%two-dimensional big array
    for i=1:68
        if board(wins(i,1)) ~= 0 && ...
           board(wins(i,1)) == board(wins(i,2)) && ... 
           board(wins(i,1)) == board(wins(i,3)) && ...
		   board(wins(i,1)) == board(wins(i,4))
            win = board(wins(i,1));
            return
        end
    end
    win = 0;
end

function draw( b)
%draws board
	for i=0:16:49
		for j=0:4:15
        fprintf(' %c | %c | %c | %c\n',gridChar(b(i+j+1)),gridChar(b(i+j+2)),gridChar(b(i+j+3)),gridChar(b(i+j+4)));
		disp('---+---+----+-----\n');
		end
		
		disp('\n')
	end
end

function a = minimax(board, depth, player) 
    if (player == -1)%transorm for filling board
        plr = 1;
    else
        plr = 2;
    end
	%How is the position like for player (their turn) on board?
    winner = win(board);
    if(winner ~= 0) %someone has won
        if (winner == 1)
            wnr = -1;
        else
            wnr = 1;
        end
        a = wnr*player;
		return
	end
	if depth == 0%depth limit exceeded
		a=0;
		return
	end
    move = -1;
    score = -2;%Losing moves are preferred to no move
    for i=1:64%For all moves,
        if(board(i) == 0)%if empty
            board(i) = plr;%try the move
			thisScore = -minimax(board, depth-1, player*(-1));
			
			if score == 1 && player==-1 || score == -1 && player==1%cant play better
				break
			end

            if(thisScore > score) %found better solution
                score = thisScore;
                move = i;
            end
            board(i) = 0;%Reset board after try

        end
    end
    if move == -1 %all cells are full
        a = 0;
        return
	end
    a = score;
end

function res = mtoV(mv) 
    k = ceil((mv)/16);
    mv = mv - 16*(k-1);
    j = ceil(mv/4);
    mv = mv - 4*(j-1);
    i = mv;
    res = [i j k]';
end

function boardArr = arrToBoard(board)
    boardArr=[];
    for i=1:4
        for j=1:4
            boardArr = cat(2, boardArr, board(j, :, i));
        end
    end
end